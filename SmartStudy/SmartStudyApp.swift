//
//  SmartStudyApp.swift
//  SmartStudy
//
//  Created by rose Hu on 10/05/2025.
//

import SwiftUI

@main
struct SmartStudyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
