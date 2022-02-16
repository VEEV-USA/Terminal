//
//  SessionDatasource.swift
//  chameleon
//
//  Created by Dare on 2/13/22.
//

import Foundation
import UIKit

class SessionDatasource {
    
    static func login(withToken token: String, completion: @escaping fetchResult) {
        guard let url = URL(string: "\(Bundle.main.apiBaseURL)/loginWithToken") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //    let jsonStr = "{\"user\": \"{ \\\"ident_token\\\": \\\"\(identToken)\\\" }\"}"
        let jsonStr = ["user": ["ident_token": token]]
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
                completion(.success(["success": true]))
            }
            
        }.resume()
    }
}
