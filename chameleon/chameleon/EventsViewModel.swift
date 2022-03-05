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
                    for i in data {
                        let event = Persistence.Events.normalize(fromJson: i)
                        DispatchQueue.main.async {
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
    
    func setupActionCable(forEvent event: String) {
        self.socket = ActionCable(withUri: Bundle.main.websocketURL)
        self.socket?.subscribe(toChannel: "CheckinChannel", sessionId: event)
    }
    
    deinit {
        print("deinit eventsVM")
    }
}


extension EventsViewModel: NSFetchedResultsControllerDelegate {}

