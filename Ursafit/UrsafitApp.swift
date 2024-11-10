//
//  UrsafitApp.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 10/28/24.
//

import SwiftUI
import SwiftData

@main
struct UrsafitApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            // TODO: Add your SwiftData models here
            // For now, we'll keep Item for reference
            Item.self,
            // Later we'll add: User.self, WorkoutEntry.self, etc.
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
            // Create a sample user for initial testing
            HomePage(viewModel: MainViewModel(user: User(
                name: "Test User",
                username: "testuser",
                currentStreak: 0,
                bearCoins: 100
            )))
        }
        .modelContainer(sharedModelContainer)
    }
}
