//
//  HealthyDeskApp.swift
//  HealthyDesk
//
//  Created by Nikhil Barik on 20/06/25.
//

import SwiftUI
import CoreData

@main
struct HealthyDeskApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
