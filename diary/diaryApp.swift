//
//  diaryApp.swift
//  diary
//
//  Created by Rodolfo Falanga on 14/11/23.
//

import SwiftUI
import SwiftData

@main
struct diaryApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            FaceId_pin()
        }
        .modelContainer(sharedModelContainer)
    }
}
