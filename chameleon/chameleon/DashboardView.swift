//
//  SwiftUIView.swift
//  chameleon
//
//  Created by Dare on 2/1/22.
//

import SwiftUI

struct CheckinModel: Decodable, Identifiable {
    let id = UUID()
    let username: String
    let date: Date
    let time: String
}

class CheckinsViewModel: ObservableObject {
    
    @Published var checkins: [CheckinModel] = [CheckinModel]()
    
    func fetchCheckins() {
        print("fetch checkins")
    }
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
                        Text(checkin.username)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer(minLength: 30)
                        Text(checkin.time)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Divider()
                }
            }
        }
        .padding(32.0)
        .onAppear(perform: {
            checkinsViewModel.fetchCheckins()
        })
    }
}

struct DashboardView: View {
    let socket: ActionCable = .init(withUri: Bundle.main.websocketURL)
    
    @State private var isActive: Bool = false
    @State private var isOverlayVisible = false
    
    private func initialize() {
        self.socket.delegate = self
        self.socket.subscribe(toChannel: "CheckinChannel", sessionId: "test123")
    }

    var body: some View {
        VStack {
            HStack {
                if #available(iOS 15.0, *) {
                    Image(uiImage: .checkmark)
                        .clipShape(Circle())
                        .frame(width: 100, height: 100, alignment: .leading)
                        .overlay {
                            Circle().stroke(.gray, lineWidth: 4)
                        }
                        .shadow(radius: 7.0)
                        .padding()
                    
                    
                    if isOverlayVisible {
                        VerifiedAnimation(isFinished: $isOverlayVisible)
                    }
                    Spacer()
                    Text("Organization")
                        .padding()
                } else {
                    Text("no go")
                }
            }
            .padding()
            Spacer(minLength: 16)
            CheckinsListView()
        }
        .navigationTitle(!isActive ? "VEEV" : "")
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(.red)
        .toolbar {
            NavigationLink("Settings", destination: SettingsView(), isActive: self.$isActive)
        }
        .onAppear(perform: {
            print("on appear")
            withAnimation {
                self.isOverlayVisible.toggle()
            }
            initialize()
        })
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            DashboardView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
