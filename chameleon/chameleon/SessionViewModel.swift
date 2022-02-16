//
//  LoginViewModel.swift
//  chameleon
//
//  Created by Dare on 2/11/22.
//

import SwiftUI
import CoreData

class SessionViewModel: ObservableObject {
    
    func serializeData(data: Data?, completion: @escaping statusResult) {
        if let _data = data, let jsonRes = try? JSONSerialization.jsonObject(with: _data, options: []) as? [String:Any] {
            if let message = jsonRes["message"] as? [String:Any] {
                guard
                    let currentUser = message["current_user"] as? [String:Any],
                    let merchant = message["merchant_information"] as? [String:Any]
                else {
                    print("cannot deserialize message data")
                    completion(.failure())
                    return
                }
                
                let identToken = currentUser["ident_token"] as? String
                SessionDatasource.login(withToken: identToken ?? "") { result in
                    switch result {
                        case .success(let userData):
                            var _userdata = userData
                            _userdata.updateValue(merchant, forKey: "merchant")
                            Persistence.Users.persist(userData: _userdata) { user in
                                Persistence.sharedManager.save()
                                completion(.ok)
                            }
                            break
                        case .failure(let err):
                            completion(.failure())
                            print(err)
                            break
                    }
                }
            }
        }
    }
}
