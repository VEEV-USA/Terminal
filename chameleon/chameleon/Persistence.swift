//
//  Persistence.swift
//  chameleon
//
//  Created by Dare on 2/7/22.
//

import CoreData
import Foundation

class Persistence: ObservableObject {
    let container = NSPersistentContainer(name: "VModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data error: \(error.localizedDescription)")
            }
        }
    }
}

extension Persistence {
    class Users {
        static func persist(userData: Dictionary<String, Any>, completion: @escaping () -> Void ) {
            //MARK: TODO
        }
    }
}

extension Persistence {
    class Checkins {
        static func persist(checkinData: Dictionary<String, Any>, completion: @escaping () -> Void ) {
            //MARK: TODO
        }
    }
}
