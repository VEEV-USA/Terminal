//
//  SwiftUIView.swift
//  chameleon
//
//  Created by Dare on 2/1/22.
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isActive: Bool = false
    @ObservedObject var merchantViewModel = MerchantViewModel()
    @ObservedObject var checkinsViewModel = CheckinsViewModel()
    
    @State var selectedUserCheckin: Checkin?
    
    var body: some View {
//        NavigationView {
            ZStack {
                VStack {
                    Text(merchantViewModel.merchant.legalName ?? "")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(8)
                    
                    HStack {
                        if (selectedUserCheckin != nil) {
                            CheckinUserInfoView(username: selectedUserCheckin?.userHandle ?? "n/a", timestamp: selectedUserCheckin?.createdAt ?? "n/a", profilePictureUrl: selectedUserCheckin?.profileImg)
                        }
                        Spacer()
                        if (merchantViewModel.merchantUserHandle != "" && merchantViewModel.merchantUserHandle != nil) {
                            QRCodeView(QRString: QRCodeType.checkin(from: merchantViewModel.merchantUserHandle ?? "") ?? "")
                        }
                    }
                    Spacer(minLength: 16)
                    CheckinsListView(checkins: $checkinsViewModel.checkins, selectedUserCheckin: $selectedUserCheckin)
                }
                .padding()
                .navigationTitle(!isActive ? "VEEV" : "")
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(false)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarColor(UIColor(named: "VEEV_RED") ?? .red)
                .toolbar {
                    HStack(spacing: 16) {
                        NavigationLink(destination: EventListView()) {
                            Image(uiImage: UIImage(named: "calendar") ?? .actions)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 20, idealWidth: 30, maxWidth: 30, minHeight: 20, idealHeight:30, maxHeight: 30, alignment: .center)
                                .colorMultiply(.white)
                        }
                        NavigationLink("Settings", destination: SettingsView())
                    }
                    
                }
                .onAppear(perform: {
                    checkinsViewModel.socket?.delegate = self
                    isActive = false
                })
                .onDisappear(perform: {
                    isActive = true
                })
            }
//        }
//        .navigationViewStyle(.stack)
    }
}

extension DashboardView: ActionCableDelegate {
    func cable(_ actionCable: ActionCable, response data: Data) {
        do {
            let decoded = try actionCable.decoder.decode(CheckInPushData.self, from: data)
            if let _ = decoded.type { return }
            self.checkinsViewModel.serializeData(data: data)
        } catch {
            print("error decoding json =>", error)
        }
    }
}



struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            DashboardView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
            DashboardView()
        }
    }
}
