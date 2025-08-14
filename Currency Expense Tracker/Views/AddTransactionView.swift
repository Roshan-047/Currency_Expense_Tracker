//
//  AddTransactionView.swift
//  Currency Expense Tracker
//
//  Created by Roshan Karn on 14/08/25.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = AddTransactionViewModel()
    var onComplete: (Bool) -> Void
    
    @State private var showValidationAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Transaction Details")) {
                    TextField("Amount", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Currency", selection: $viewModel.currency) {
                        ForEach(viewModel.currencies, id: \.self) { Text($0) }
                    }
                    
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(viewModel.categories, id: \.self) { Text($0) }
                    }
                    
                    TextField("Description (optional)", text: $viewModel.desc)
                        .onChange(of: viewModel.desc) { newValue in
                            viewModel.desc = String(newValue.prefix(100))
                        }
                }
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if let enteredAmount = Double(viewModel.amount), enteredAmount > 0 {
                            viewModel.addTransaction(viewContext: viewContext)
                            dismiss()
                            onComplete(true)
                        } else {
                            showValidationAlert = true
                        }
                    }
                }
            }
            .alert("Invalid Amount", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please enter an amount greater than 0.")
            }
        }
    }
}
