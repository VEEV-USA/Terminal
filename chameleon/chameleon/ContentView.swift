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
        LandingView()
            .fullScreenCover(isPresented: $authService.isAuth, onDismiss: nil) {
                DashboardView()
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

class AuthService: ObservableObject {
    @Published var isAuth: Bool = false
}
