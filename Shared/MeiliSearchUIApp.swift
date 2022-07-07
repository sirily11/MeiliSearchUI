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
    @StateObject var meilisearchModel = MeilisearchModel()

    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(meilisearchModel)
        }
    }
}
