//
//  CheckApp.swift
//  Check
//
//  Created by Sebastian Stoelen on 09/04/2025.
//

import SwiftUI

@main
struct CheckApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Habit.self, HabitCompletion.self])
    }
}
