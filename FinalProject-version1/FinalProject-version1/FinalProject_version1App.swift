//
//  FinalProject_version1App.swift
//  FinalProject-version1
//
//  Created by Bao Huynh on 3/30/23.
//

import SwiftUI

@main
struct FinalProject_version1App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(cityName: "")
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
