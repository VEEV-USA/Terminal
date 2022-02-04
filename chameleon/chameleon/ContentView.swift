//
//  ContentView.swift
//  chameleon
//
//  Created by Dare on 1/28/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.pink.ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("VEEV")
                    .font(.title)
                    .foregroundColor(.white)
                HStack {
                    Text("Checkins")
                        .font(.subheadline)
                    Spacer()
                    Text("Bay Area")
                        .font(.subheadline)
                }
            }
            .padding()
            .accentColor(.white)
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
