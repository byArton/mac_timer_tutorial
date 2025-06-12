//
//  timeApp.swift
//  time
//
//  Created by Arton on 2025/06/12.
//

import SwiftUI

@main
struct timeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
