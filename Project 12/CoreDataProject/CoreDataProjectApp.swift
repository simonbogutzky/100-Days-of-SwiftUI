//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Simon Bogutzky on 13.11.20.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
