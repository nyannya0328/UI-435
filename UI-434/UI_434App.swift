//
//  UI_434App.swift
//  UI-434
//
//  Created by nyannyan0328 on 2022/01/24.
//

import SwiftUI

@main
struct UI_434App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
