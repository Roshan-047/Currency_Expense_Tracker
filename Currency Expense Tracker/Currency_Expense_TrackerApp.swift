//
//  Currency_Expense_TrackerApp.swift
//  Currency Expense Tracker
//
//  Created by Roshan Karn on 14/08/25.
//

import SwiftUI
import CoreData

@main
struct Currency_Expense_TrackerApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
