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
    
    var body: some View {
        HStack {
           ProfilePictureView()
                .padding()
            VStack {
                Text("User: \(username)").padding(.vertical, 2)
                Text("timestamp: \(timestamp)").padding(.vertical, 2)
                Text("Username: ...").padding(.vertical, 2)
                Text("Username: ...").padding(.vertical, 2)
            }
            .padding()
            VerifiedAnimation()
                .padding()
        }
        .frame(minWidth: 100.0, idealWidth: 200.0, maxWidth: 500.0, minHeight: 100)
        .border(Color.black)
        .padding()
    }
}
