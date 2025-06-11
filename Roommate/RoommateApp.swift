//
//  RoommateApp.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import SwiftUI

@main
struct RoommateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
