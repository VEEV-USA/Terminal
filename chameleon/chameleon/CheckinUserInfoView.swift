//
//  CheckinUserInfoView.swift
//  chameleon
//
//  Created by Dare on 2/22/22.
//

import SwiftUI

struct CheckinUserInfoView: View {

    let username: String
    let timestamp: String
    var _timestamp: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy hh:mm a"
            let date = Persistence.dateFormatter.date(from: timestamp) ?? Date()
            return dateFormatter.string(from: date)
        }
    }
    let profilePictureUrl: String?
    
    var body: some View {
        HStack {
            ProfilePictureView(
                url: URL(string: profilePictureUrl ?? "http://localhost:5000")!,
                placeholder: { Text("loading...") }
            )
                .padding()
            VStack(alignment: .leading) {
                Text("**User:** \(username)").padding(.vertical, 1).foregroundColor(.black)
                Text("**Timestamp:** \(_timestamp)").padding(.vertical, 1).foregroundColor(.black)
                Text("**Phone:** \(_timestamp)").padding(.vertical, 1).foregroundColor(.black)
                
            }
            .padding()
            VStack(alignment: .leading) {
                HStack {
                    Text("**Driver's License:**").padding(1).foregroundColor(.black)
                    VerifiedAnimation(width: 20, height: 20)
                }
                HStack {
                    Text("**Credit Card:**").padding(1).foregroundColor(.black)
                    VerifiedAnimation(width: 20, height: 20)
                }
            }
            .padding()
        }
        .frame(minWidth: 100.0, idealWidth: 200.0, maxWidth: 600.0, minHeight: 100)
        .border(Color.black)
    }
}
