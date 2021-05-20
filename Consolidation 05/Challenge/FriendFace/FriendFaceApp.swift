//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Simon Bogutzky on 17.11.20.
//

import SwiftUI

@main
struct FriendFaceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
