//
//  SwiftUIView.swift
//  chameleon
//
//  Created by Dare on 2/1/22.
//

import SwiftUI

struct Checkin: Decodable, Identifiable {
    let id = UUID()
    let username: String
    let date: Date
    let time: String
}

class CheckinsViewModel: ObservableObject {
    
    @Published var checkins: [Checkin] = [Checkin]()
    
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
    
    @State private var isActive: Bool = false
    
    var body: some View {
        NavigationView {
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            print("on appear")
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
