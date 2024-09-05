//
//  bioengineering_swift_demoApp.swift
//  bioengineering_swift_demo
//
//  Created by Osk Mar on 31.08.24.
//

import SwiftUI
import SwiftData

@main
struct bioengineering_swift_demoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ECGItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
