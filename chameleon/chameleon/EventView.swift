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
                    QRCodeView(QRString: QRCodeType.event(from: event.id) ?? "")
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
            eventsVM.setupActionCable(forEvent: event)
            eventsVM.socket?.delegate = self
            eventsVM.getCheckins(eventId: event.id) { result in
                switch result {
                case .success(let data):
                    let checkins = data["checkins"] as! [Dictionary<String, Any>]
                    for checkin in checkins {
                        let c = Checkin(context: Persistence.sharedManager.session.viewContext)
                        c.id = checkin["id"] as? Int32 ?? -1
                        c.userId = checkin["user_id"] as? Int32 ?? -1
                        c.userHandle = checkin["user_handle"] as? String ?? ""
                        c.profileImg = checkin["profile_img"] as? String
                        c.createdAt = checkin["created_at"] as? String ?? ""
                        DispatchQueue.main.async {
                            eventsVM.checkins = [c] + eventsVM.checkins
                        }
                    }
                    break
                case .failure(let err):
                    print("error fetching Event Checkins =>", err)
                    break
                }
            }
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
