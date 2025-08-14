//
//  AddTransactionViewModel.swift
//  Currency Expense Tracker
//
//  Created by Roshan Karn on 14/08/25.
//

import Foundation
import CoreData
import SwiftUI

class AddTransactionViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var currency: String = "INR"
    @Published var category: String = "Food"
    @Published var desc: String = ""
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    let categories = ["Food", "Travel", "Utilities", "Other"]
    let currencies = ["INR", "USD"]
    
    init() { }
    
    func addTransaction(viewContext: NSManagedObjectContext) {
        guard let enteredAmount = Double(amount), enteredAmount > 0 else {
            alertMessage = "Please enter a positive amount."
            showingAlert = true
            return
        }
        
        let newTransaction = TransactionEntity(context: viewContext)
        newTransaction.amount = enteredAmount
        newTransaction.currency = currency
        newTransaction.category = category
        newTransaction.desc = desc
        newTransaction.timestamp = Date()
        
        if currency == "USD" {
            let exchangeRate = APIManager.shared.exchangeRate
            if exchangeRate > 0 {
                newTransaction.convertedAmountINR = enteredAmount * exchangeRate
            } else {
                newTransaction.convertedAmountINR = 0.0
            }
        } else {
            newTransaction.convertedAmountINR = enteredAmount
        }
        
        do {
            try viewContext.save()
            amount = ""
            currency = "INR"
            category = "Food"
            desc = ""
        } catch {
            print("Failed to save transaction: \(error.localizedDescription)")
            alertMessage = "Failed to save transaction. Please try again."
            showingAlert = true
        }
    }
}
