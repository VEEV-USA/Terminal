//
//  EventView.swift
//  chameleon
//
//  Created by Dare on 3/3/22.
//

import SwiftUI

struct EventView: View {
    var event: Event
    
    @State var selectedUserCheckin: Checkin?
    
    var body: some View {
        VStack {
            Text(event.name ?? "")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding(8)
            HStack {
                if (selectedUserCheckin != nil) {
                    CheckinUserInfoView(username: selectedUserCheckin?.userHandle ?? "n/a", timestamp: selectedUserCheckin?.createdAt ?? "n/a", profilePictureUrl: selectedUserCheckin?.profileImg)
                }
                Spacer()
                if (event.name != nil) {
                    QRCodeView(QRString: QRCodeType.event(from: event.name!) ?? "")
                }
            }
            Spacer(minLength: 16)
//            CheckinsListView(checkins: $checkinsViewModel.checkins, selectedUserCheckin: $selectedUserCheckin)
        }
        .padding()
        .navigationBarColor(UIColor(named: "VEEV_RED") ?? .red)
        .toolbar {
                NavigationLink("Settings", destination: SettingsView())
        }
        .foregroundColor(.white)
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: Event())
    }
}
