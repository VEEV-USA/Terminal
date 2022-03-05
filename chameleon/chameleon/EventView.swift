//
//  EventView.swift
//  chameleon
//
//  Created by Dare on 3/3/22.
//

import SwiftUI

struct EventView: View {
    var event: Event
    @ObservedObject var eventsVM: EventsViewModel = EventsViewModel()
    @Binding var checkins: [Checkin]
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
            CheckinsListView(checkins: $eventsVM.checkins, selectedUserCheckin: $selectedUserCheckin)
                .foregroundColor(.black)
        }
        .padding()
        .navigationBarColor(UIColor(named: "VEEV_RED") ?? .red)
        .toolbar {
                NavigationLink("Settings", destination: SettingsView())
        }
        .foregroundColor(.white)
        .onAppear {
            eventsVM.setupActionCable(forEvent: event.name ?? "")
            eventsVM.socket?.delegate = self
        }
        .onDisappear {
            eventsVM.socket?.delegate = nil
        }
    }
}

extension EventView: ActionCableDelegate {
    func cable(_ actionCable: ActionCable, response data: Data) {
        do {
            let decoded = try actionCable.decoder.decode(CheckInPushData.self, from: data)
            if let _ = decoded.type { return }
            self.eventsVM.serializeData(data: data)
        } catch {
            print("error decoding json =>", error)
        }
    }
}

//
//struct EventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventView(event: Event(), checkins: )
//    }
//}
