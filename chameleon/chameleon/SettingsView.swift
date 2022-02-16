//
//  SettingsView.swift
//  chameleon
//
//  Created by Dare on 2/4/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject private var authService: AuthService
    
    private func signout() {
        let entities = ["User", "Merchant", "Checkin"]
        entities.forEach { entity in
            Persistence.sharedManager.clear(entity: entity)
        }
        DispatchQueue.main.async {
            self.authService.isAuth = false
        }
    }
    
    private func clearPersistentStore() {}
        
    var body: some View {
        Form {
            Section {
                Button("Sign out") {
                    signout()
                }
                .foregroundColor(.black)
            } footer: {
                Text("v\(Bundle.main.releaseVersion) build \(Bundle.main.buildVersion)")
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle(Text("Settings"))
        .navigationBarColor(UIColor(named: "VEEV_RED") ?? .red)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
