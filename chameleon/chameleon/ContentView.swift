//
//  ContentView.swift
//  chameleon
//
//  Created by Dare on 1/28/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        //        LandingView()
        //            .fullScreenCover(isPresented: $authService.isAuth, onDismiss: nil) {
        //                DashboardView()
        //            }
        if (authService.isAuth) {
            withAnimation {
                NavigationView {
                    DashboardView()
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
                }
                .navigationViewStyle(.stack)
            }
        }
        else {
            LandingView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            ContentView()
        }
    }
}

