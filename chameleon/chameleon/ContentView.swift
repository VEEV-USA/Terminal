//
//  ContentView.swift
//  chameleon
//
//  Created by Dare on 1/28/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var isAuth = false
    
    var body: some View {
        NavigationView {
            if isAuth {
                DashboardView().transition(.asymmetric(insertion: .identity, removal: .opacity))
                    .statusBarStyle(.lightContent)
            } else {
                LandingView(isAuth: $isAuth)
                    .statusBarStyle(.lightContent)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
