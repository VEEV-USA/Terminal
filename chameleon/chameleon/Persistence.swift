//
//  Persistence.swift
//  chameleon
//
//  Created by Dare on 2/7/22.
//

import CoreData
import Foundation

class Persistence: ObservableObject {
    private static var instance: Persistence?
    static var sharedManager: Persistence {
        get {
            if let _instance = instance {
                return _instance
            }
            let newInstance = Persistence()
            instance = newInstance
            return newInstance
        }
    }
    
    let container = NSPersistentContainer(name: "VDataModel")
    
    static let dateFormatter: DateFormatter! = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    private init() {
        self.loadContainer()
    }
    
    func loadContainer() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func save() {
        let moc = container.viewContext
        do {
            try moc.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
        
    func clear(entity: String) {
        let moc = container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try moc.execute(deleteRequest)
        } catch let error as NSError {
            print("Error deleting from coredata")
        }
    }
}

extension Persistence {
    class Users {
        static var user: User?
        
        static func persist(userData: Dictionary<String, Any>, completion: @escaping (User) -> Void ) {
            let moc = Persistence.sharedManager.container.viewContext
            let user = User(context: moc)
            let merchant = Merchant(context: moc)
            user.id = (userData["id"] as? Int32)!
            user.email = userData["email"] as? String
            user.identToken = userData["ident_token"] as? String
            if let merchantData = userData["merchant"] as? Dictionary<String, Any> {
                merchant.id = merchantData["id"] as! Int32
                merchant.merchantCode = merchantData["merchant_code"] as? String
                merchant.legalName = merchantData["legal_name"] as? String
                merchant.address = merchantData["street"] as? String
                merchant.city = merchantData["city"] as? String
                merchant.state = merchantData["state"] as? String
                merchant.zip = merchantData["zip"] as? String
                merchant.phone = merchantData["phone"] as? String
                merchant.merchantUserId = merchantData["user_id"] as? Int32 ?? -1
                user.merchant = merchant
            }
            
            completion(user)
        }
        
        static func getUser( ) -> User? {
            let moc = Persistence.sharedManager.container.viewContext
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            var user: User?
            do {
                user = try moc.fetch(fetchRequest).first
            } catch {
                print("error fetching user")
            }
            return user
        }
            
    }
}


extension Persistence {
    class Merchants {
        static var merchant: Merchant?
    }
}

extension Persistence {
    class Checkins {
        static var checkins: [Checkin] = [Checkin]()
        static func persist(checkinData: Dictionary<String, Any>, completion: @escaping () -> Void ) {
            //MARK: TODO
        }
        
        static func normalize(from json: [String:Any]) -> Checkin {
            let checkin = Checkin(context: Persistence.sharedManager.container.viewContext)
            checkin.id = json["id"] as? Int32 ?? -1
            checkin.merchantId = json["merchant_id"] as? Int32 ?? -1
            checkin.userId = json["user_id"] as? Int32 ?? -1
            checkin.userHandle = json["user_handle"] as? String ?? ""
            checkin.profileImg = json["profile_img"] as? String ?? ""
            checkin.createdAt = json["created_at"] as? String ?? ""
            return checkin
        }
    }
}


