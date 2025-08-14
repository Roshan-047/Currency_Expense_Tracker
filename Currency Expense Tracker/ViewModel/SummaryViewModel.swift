//
//  SummaryViewModel.swift
//  Currency Expense Tracker
//
//  Created by Roshan Karn on 14/08/25.
//

import Foundation
import SwiftUI
import CoreData

class SummaryViewModel: ObservableObject {
    @Published var totalSpend: Double = 0
    @Published var transactionCount: Int = 0
    @Published var categoryBreakdown: [String: Double] = [:]
    
    let categoryColors: [String: Color] = [
        "Food": .red,
        "Travel": .blue,
        "Utilities": .green,
        "Other": .gray
    ]
    
    init() { }
    
    func updateSummary(transactions: FetchedResults<TransactionEntity>) {
        totalSpend = transactions.reduce(0) { $0 + $1.convertedAmountINR }
        transactionCount = transactions.count
        categoryBreakdown = transactions.reduce(into: [:]) { result, transaction in
            result[transaction.category ?? "Other", default: 0] += transaction.convertedAmountINR
        }
    }
    
    func updateUnconvertedTransactions(viewContext: NSManagedObjectContext) async {
        let exchangeRate = APIManager.shared.exchangeRate
        
        guard exchangeRate > 0 else { return }
        
        do {
            let fetchRequest: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "convertedAmountINR == 0 AND currency == 'USD'")
            
            let unconvertedTransactions = try viewContext.fetch(fetchRequest)
            
            for transaction in unconvertedTransactions {
                transaction.convertedAmountINR = transaction.amount * exchangeRate
            }
            
            if !unconvertedTransactions.isEmpty {
                try viewContext.save()
                print("Updated \(unconvertedTransactions.count) unconverted transactions.")
            }
        } catch {
            print("Failed to fetch or update unconverted transactions: \(error)")
        }
    }
}
