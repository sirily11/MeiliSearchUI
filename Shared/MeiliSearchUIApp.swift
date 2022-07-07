//
//  MeiliSearchUIApp.swift
//  Shared
//
//  Created by Qiwei Li on 7/7/22.
//

import SwiftUI

@main
struct MeiliSearchUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
