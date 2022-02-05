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
        if isAuth {
            DashboardView()
        } else {
            LandingView(isAuth: $isAuth)
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
