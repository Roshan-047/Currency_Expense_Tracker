//
//  ContentView.swift
//  Currency Expense Tracker
//
//  Created by Roshan Karn on 14/08/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var apiManager = APIManager.shared
    
    var body: some View {
        SummaryView()
            .environmentObject(apiManager)
            .onAppear {
                Task {
                    await apiManager.fetchExchangeRate()
                }
            }
    }
}

#Preview {
    ContentView()
}
