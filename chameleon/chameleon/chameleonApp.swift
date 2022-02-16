//
//  chameleonApp.swift
//  chameleon
//
//  Created by Dare on 1/28/22.
//

import SwiftUI

@main
struct chameleonApp: App {
    @StateObject private var dataLayer = Persistence.sharedManager
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataLayer.container.viewContext)
                .environmentObject(AuthService())
        }
    }
}
