//
//  EventsViewModel.swift
//  chameleon
//
//  Created by Dare on 2/28/22.
//

import SwiftUI
import CoreData

class EventsViewModel: NSObject, ObservableObject {
    
    @Published var events: [Event] = [Event]()
    @Published var checkins: [Checkin] = [Checkin]()

    var socket: ActionCable?
    var delegate: CheckinDelegate?
    
    func serializeData(data: Data?) {
        if let _data = data, let jsonRes = try? JSONSerialization.jsonObject(with: _data, options: []) as? [String:Any] {
            if let message = jsonRes["message"] as? [String:Any] {
                guard let checkinInfo = message["checkin_info"] as? [String:Any]
                else { print("error with json format"); return }
                DispatchQueue.main.async {
                    let checkin = Persistence.Checkins.normalize(from: checkinInfo)
                     self.checkins = [checkin] + self.checkins
                    Persistence.Checkins.checkins.append(checkin)
                    self.saveData(data: checkin)
                }
            }
        }
    }
    
    func saveData(data: Checkin) {
        Persistence.Checkins.persist(checkin: data) { response in
            Persistence.sharedManager.save()
        }
    }
    
    override init () {
        super.init()
        guard let user = Persistence.Users.getUser() else { print ("cannot get user!"); return; }
        EventsDatasource.get(user: user) { result in
            switch result {
                case .success(let data):
                DispatchQueue.main.async {

                    for i in data {
                        let event = Persistence.Events.normalize(fromJson: i)
                            self.events.append(event)
                        }
                    }
                    break
                case .failure(let err):
                    print(err)
                    break
            }
        }
    }
    
    func setupActionCable(forEvent event: Event) {
        self.socket = ActionCable(withUri: Bundle.main.websocketURL)
        //channel - checkin_{merchant_code}{eventid}
        let sessionId = "\(event.organizer ?? "")\(event.eventId)"
        self.socket?.subscribe(toChannel: "CheckinChannel", sessionId: sessionId)
    }
    
    deinit {
        print("deinit eventsVM")
    }
}

extension EventsViewModel {
    func getCheckins(eventId: Int32, completion: @escaping fetchResult) {
        guard let user = Persistence.Users.getUser() else { print ("cannot get user!"); return; }
        guard let merchant_id = Persistence.Merchants.merchant?.id, let url = URL(string: "\(Bundle.main.apiBaseURL)/get_event_checkin") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue(user.email, forHTTPHeaderField: "X-User-Email")
        request.setValue(user.identToken, forHTTPHeaderField: "X-User-Token")
        
        let jsonStr = ["param": ["event_id": eventId]]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonStr)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, res, err) in
            if (err != nil) {
                print("Error", err)
                completion(.failure(HttpError(title: url.description, description: err?.localizedDescription ?? "Error...", code: -1)))
                return
            }
            guard let response = res as? HTTPURLResponse else { return }
            if (response.statusCode != 200) {
                print("Status Code =>", response.statusCode, url)
                completion(.failure(HttpError(title: url.description, description: response.description, code: response.statusCode)))
                return
            }
            
            if let _data = data, let jsonRes = try? JSONSerialization.jsonObject(with: _data, options: []) as? [String:Any] {
                completion(.success(jsonRes))
            } else {
                completion(.failure(HttpError(title: url.description, description: "can't parse json", code: -1)))
            }
            
        }.resume()
    }
}

extension EventsViewModel: NSFetchedResultsControllerDelegate {}

