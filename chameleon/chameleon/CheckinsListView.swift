//
//  CheckinsListView.swift
//  chameleon
//
//  Created by Dare on 2/22/22.
//

import SwiftUI

struct CheckinModel: Decodable, Identifiable {
    let id = UUID()
    let username: String
    let date: Date
    let time: String
}

protocol CheckinDelegate {
    func checkin(_ checkin: Checkin)
}

struct CheckinsListView: View {
    @Binding var checkins: [Checkin]
    @Binding var selectedUserCheckin: Checkin?
    
    var body: some View {
        VStack {
            HStack() {
                Text("User")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 30)
                Text("Time")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 16)
            ScrollView {
                ForEach(checkins) { checkin in
                    Button {
                        self.selectedUserCheckin = checkin
                        withAnimation {
                            DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
                                self.selectedUserCheckin = nil
                            }
                        }
                    } label: {
                        CheckinRowView(checkin: checkin)
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 4)
                        Divider()
                }
            }
        }
        .padding(32.0)

    }
}
