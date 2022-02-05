//
//  SettingsView.swift
//  chameleon
//
//  Created by Dare on 2/4/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
    var body: some View {
        Form {
            Section {
                Button("Sign out") {
                    print("sign out pressed")
                }
                .foregroundColor(.black)
            }
        }
        .navigationTitle(Text("Settings"))
        .navigationBarColor(.red)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
