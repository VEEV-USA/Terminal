//
//  EventsDatasource.swift
//  chameleon
//
//  Created by Dare on 2/28/22.
//

import Foundation

class EventsDatasource {
    
    static func get(user: User, completion: @escaping fetchResults) {
        guard let merchant_id = Persistence.Merchants.merchant?.id, let url = URL(string: "\(Bundle.main.apiBaseURL)/merchants/\(merchant_id)/events") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue(user.email, forHTTPHeaderField: "X-User-Email")
        request.setValue(user.identToken, forHTTPHeaderField: "X-User-Token")
        
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
            
            if let _data = data, let jsonRes = try? JSONSerialization.jsonObject(with: _data, options: []) as? [[String:Any]] {
                completion(.success(jsonRes))
            } else {
                completion(.failure(HttpError(title: url.description, description: "can't parse json", code: -1)))
            }
            
        }.resume()
    }
}
