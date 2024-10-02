//
//  BookNestAppApp.swift
//  BookNestApp
//
//  Created by Neslihan Turpcu on 2024-10-02.
//

import SwiftUI

@main
struct BookNestAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
