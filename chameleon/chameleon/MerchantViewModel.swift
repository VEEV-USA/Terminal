//
//  MerchantViewModel.swift
//  chameleon
//
//  Created by Dare on 2/13/22.
//

import SwiftUI
import CoreData

class MerchantViewModel: NSObject, ObservableObject {
    @Published private var _merchant: Merchant?
    @Published var merchantUserHandle: String?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Merchant> = {
        let fetchRequest: NSFetchRequest<Merchant> = NSFetchRequest(entityName: "Merchant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let FRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Persistence.sharedManager.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        FRC.delegate = self
        return FRC
    }()
    
    var merchant: Merchant {
        get {
            if let __merchant = _merchant {
                return __merchant
            }
            let emptyMerchant = Merchant(context: Persistence.sharedManager.container.viewContext)
            emptyMerchant.id = -1
            emptyMerchant.legalName = "Not Found"
            return emptyMerchant
        }
        set {
            _merchant = newValue
        }
    }
    
    func getMerchant() {
        do {
            try self.fetchedResultsController.performFetch()
            if let result = fetchedResultsController.fetchedObjects?.first, let obj = result as? Merchant{
                print("merchant loaded =>", result)
                self.merchant = obj
                Persistence.Users.user = merchant.user
                Persistence.Merchants.merchant = merchant
                getUserHandle()
            }
        } catch {
            let err = error as NSError
            print("Unable to perform fetch")
            print("\(err), \(err.localizedDescription)")
        }
    }
    
    func getUserHandle() {
        guard let user = Persistence.Users.getUser() else { return }
        MerchantDatasource.getMerchantHandle(user: user) { result in
            switch result {
                case .success(let data):
                    if let user = data["user"] as? [String:Any], let handle = user["handle"] as? String {
                        DispatchQueue.main.async {
                            self.merchantUserHandle = handle
                        }
                    }
                    break
                case .failure(let err):
                    print("error", err)
                    break
            }
        }
    }
    
    override init() {
        super.init()
        getMerchant()
    }
    
    deinit {
        print("deinitializing merchantVM")
    }
}

extension MerchantViewModel: NSFetchedResultsControllerDelegate {
    
}
