//
//  CheckinsViewModel.swift
//  chameleon
//
//  Created by Dare on 2/13/22.
//

import CoreData

class CheckinsViewModel: NSObject, ObservableObject {
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Checkin> = {
        let fetchRequest: NSFetchRequest<Checkin> = NSFetchRequest(entityName: "Checkin")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let FRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: Persistence.sharedManager.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        FRC.delegate = self
        return FRC
    }()
    
    var socket: ActionCable?
    
    @Published var checkins: [Checkin] = [Checkin]()
    static var delegate: CheckinDelegate?
    
    func fetchCheckins() {
    }
    
    func getLocalCheckins() {
        do {
            try self.fetchedResultsController.performFetch()
            if let result = fetchedResultsController.fetchedObjects, let objects = result as? [Checkin] {
                self.checkins = objects
            }
        } catch {
            let err = error as NSError
            print("Unable to perform fetch")
            print("\(err), \(err.localizedDescription)")
        }
    }
    
    func serializeData(data: Data?) {
        if let _data = data, let jsonRes = try? JSONSerialization.jsonObject(with: _data, options: []) as? [String:Any] {
            if let message = jsonRes["message"] as? [String:Any] {
                guard let checkinInfo = message["checkin_info"] as? [String:Any]
                else { print("error with json format"); return }
                DispatchQueue.main.async {
                    let checkin = Persistence.Checkins.normalize(from: checkinInfo)
                     self.checkins = [checkin] + self.checkins
                    Persistence.Checkins.checkins.append(checkin)
                    CheckinsViewModel.delegate?.checkin(checkin)
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
    
    func setupActionCable() {
        self.socket = ActionCable(withUri: Bundle.main.websocketURL)
        self.socket?.subscribe(toChannel: "CheckinChannel", sessionId: Persistence.Merchants.merchant?.merchantCode)
    }
    
    override init() {
        super.init()
        getLocalCheckins()
        setupActionCable()
    }
    
    deinit {
        print("deinit checkinVM")
        self.socket?.delegate = nil
        self.socket?.unsubscribe(toChannel: "CheckinChannel")
    }

}

extension CheckinsViewModel: NSFetchedResultsControllerDelegate {}
