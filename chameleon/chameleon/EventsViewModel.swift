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
}


extension EventsViewModel: NSFetchedResultsControllerDelegate {}

