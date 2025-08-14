//
//  SummaryView.swift
//  Currency Expense Tracker
//
//  Created by Roshan Karn on 14/08/25.
//

import SwiftUI
import CoreData
import Charts

struct SummaryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = SummaryViewModel()
    @ObservedObject private var apiManager = APIManager.shared
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.timestamp, ascending: false)],
        animation: .default
    )
    private var transactions: FetchedResults<TransactionEntity>
    
    @State private var showingAddTransaction = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Total Spend
                    Group {
                        Text("Total Spend")
                            .font(.headline)
                        Text("₹\(viewModel.totalSpend, specifier: "%.2f")")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    // Transaction Count
                    Group {
                        Text("Total Transactions")
                            .font(.headline)
                        Text("\(viewModel.transactionCount)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    Divider()
                    
                    // Category Breakdown
                    Text("Category Breakdown")
                        .font(.headline)
                    
                    if !viewModel.categoryBreakdown.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            if !viewModel.categoryBreakdown.isEmpty {

                                Chart {
                                    ForEach(viewModel.categoryBreakdown.keys.sorted(), id: \.self) { category in
                                        if let amount = viewModel.categoryBreakdown[category] {
                                            SectorMark(
                                                angle: .value("Amount", amount),
                                                innerRadius: .ratio(0.5),
                                                angularInset: 2
                                            )
                                            .foregroundStyle(viewModel.categoryColors[category] ?? .gray)
                                        }
                                    }
                                }
                                .frame(height: 220)
                                .padding()
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                    ForEach(viewModel.categoryBreakdown.keys.sorted(), id: \.self) { category in
                                        if let amount = viewModel.categoryBreakdown[category] {
                                            HStack {
                                                Circle()
                                                    .fill(viewModel.categoryColors[category] ?? .gray)
                                                    .frame(width: 12, height: 12)
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(category)
                                                        .font(.subheadline)
                                                        .fontWeight(.medium)
                                                    Text("₹\(amount, specifier: "%.2f")")
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                        }
                                    }
                                }


                                .chartBackground { proxy in
                                    Circle()
                                        .fill(Color(UIColor.systemBackground))
                                        .frame(width: 100, height: 100)
                                        .overlay(
                                            VStack {
                                                Text("Total")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Text("₹\(viewModel.totalSpend, specifier: "%.0f")")
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                            }
                                        )
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(UIColor.secondarySystemBackground))
                                        .shadow(radius: 4)
                                )
                            } else {
                                Text("No transactions to display.")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    } else {
                        Text("No transactions to display.")
                    }
                    
                    Divider()
                    
                    Text("Recent Transactions")
                        .font(.headline)
                    
                    if transactions.isEmpty {
                        Text("No recent transactions")
                            .foregroundColor(.secondary)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(transactions, id: \.self) { transaction in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(transaction.category ?? "Unknown")
                                            .font(.subheadline)
                                            .foregroundColor(viewModel.categoryColors[transaction.category ?? "Other"])
                                        Spacer()
                                        
                                        if transaction.currency == "USD" {
                                            if transaction.convertedAmountINR == 0 {
                                                Text("$\(transaction.amount, specifier: "%.2f") → Waiting for internet connection to convert")
                                                    .font(.caption)
                                                    .foregroundColor(.orange)
                                            } else {
                                                Text("$\(transaction.amount, specifier: "%.2f") → ₹\(transaction.convertedAmountINR, specifier: "%.2f")")
                                                    .fontWeight(.bold)
                                            }
                                        } else {
                                            Text("₹\(transaction.amount, specifier: "%.2f")")
                                                .fontWeight(.bold)
                                        }
                                    }
                                    
                                    if let desc = transaction.desc, !desc.isEmpty {
                                        Text(desc)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    if let timestamp = transaction.timestamp {
                                        Text(timestamp, style: .date)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Divider()
                            }
                        }

                    }
                }
                .padding()
            }
            .navigationTitle("Summary")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTransaction = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView { success in
                    if success { showSuccessAlert = true }
                }
                .environment(\.managedObjectContext, viewContext)
            }
            .alert("Transaction Added", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your transaction has been added successfully.")
            }
            .onAppear {
                viewModel.updateSummary(transactions: transactions)
                if apiManager.exchangeRate > 0 {
                    Task { await viewModel.updateUnconvertedTransactions(viewContext: viewContext) }
                }
            }
            .onChange(of: transactions.count) { _ in
                viewModel.updateSummary(transactions: transactions)
            }
            .onChange(of: apiManager.exchangeRate) { _ in
                if apiManager.exchangeRate > 0 {
                    Task { await viewModel.updateUnconvertedTransactions(viewContext: viewContext) }
                }
            }
        }
    }
}



//#Preview {
//    SummaryView()
//}
