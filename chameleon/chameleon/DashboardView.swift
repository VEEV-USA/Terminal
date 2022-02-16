//
//  SwiftUIView.swift
//  chameleon
//
//  Created by Dare on 2/1/22.
//

import SwiftUI
import CoreData

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
    @ObservedObject var checkinsViewModel = CheckinsViewModel()
    
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
                ForEach(checkinsViewModel.checkins) { checkin in
                    HStack {
                        Text(checkin.userHandle ?? "n/a")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer(minLength: 30)
                        Text(checkin.createdAt ?? "n/a")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Divider()
                }
            }
        }
        .padding(32.0)
        .onAppear {
            print("checkin appear")
            checkinsViewModel.setupActionCable()
            checkinsViewModel.socket?.delegate = self
        }
        .onDisappear {
            checkinsViewModel.socket?.delegate = nil
        }

    }
}

struct DashboardView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var isActive: Bool = false
    @ObservedObject var merchantViewModel = MerchantViewModel()
    
    let checkinsListView = CheckinsListView()

    var body: some View {
        NavigationView {
        VStack {
            HStack {
                if #available(iOS 15.0, *) {
                    Image("ic_person")
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100, alignment: .center)
                        .overlay {
                            Circle().stroke(.gray, lineWidth: 4)
                        }
                        .shadow(radius: 7.0)
                        .padding()
                } else {
                        Image(uiImage: .checkmark)
                            .clipShape(Circle())
                            .frame(width: 100, height: 100, alignment: .leading)
                            .shadow(radius: 7.0)
                            .padding()
                }
                
                VerifiedAnimation()
                Spacer()
                Text(merchantViewModel.merchant.legalName ?? "")
                    .fontWeight(.semibold)
                    .padding()
                
                if (merchantViewModel.merchantUserHandle != "" && merchantViewModel.merchantUserHandle != nil) {
                    QRCodeView(QRString: QRCodeEventType.checkin(merchantUserHandle: merchantViewModel.merchantUserHandle ?? "") ?? "")
                }
            }
            .padding()
            Spacer(minLength: 16)
            checkinsListView
        }
        .navigationTitle(!isActive ? "VEEV" : "")
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(UIColor(named: "VEEV_RED") ?? .red)
        .toolbar {
            NavigationLink("Settings", destination: SettingsView(), isActive: self.$isActive)
        }
        .onAppear(perform: {
            print("dashboard appear")
        })
        .onDisappear {
            print("dashboard disappeared")
        }}
        .navigationViewStyle(.stack)
    }
}

extension CheckinsListView: ActionCableDelegate {
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
