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
                url: URL(string: profilePictureUrl ?? "")!,
                placeholder: { Text("loading...") }
            )
                .padding()
            VStack {
                Text("**User:** \(username)").padding(.vertical, 2)
                Text("**timestamp:** \(_timestamp)").padding(.vertical, 2)
            }
            .padding()
            VerifiedAnimation()
                .padding()
        }
        .frame(minWidth: 100.0, idealWidth: 200.0, maxWidth: 500.0, minHeight: 100)
        .border(Color.black)
    }
}
