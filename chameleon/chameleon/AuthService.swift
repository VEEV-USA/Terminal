//
//  AuthService.swift
//  chameleon
//
//  Created by Dare on 2/16/22.
//

import SwiftUI
import CoreData

class AuthService: ObservableObject {
    @Published var isAuth: Bool = false
    
    
    init() {
        let fetchRequest: NSFetchRequest<User> = NSFetchRequest(entityName: "User")
        fetchRequest.fetchLimit = 1
        do {
            if let _ = try Persistence.sharedManager.container.viewContext.fetch(fetchRequest).first {
                isAuth.toggle()
            }
        } catch {
            print("cannot fetch user ", error.localizedDescription)
        }
    }
}
