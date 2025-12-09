//
//  ActivityViewModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 09/12/2025.
//

import SwiftUI
import Combine
import RealmSwift

// MARK: - Activity ViewModel
class ActivityViewModel: ObservableObject {
    
    // MARK: - Published properties
    
    @Published var searchText: String = ""
    @Published var showFilter: Bool = false    
    @Published var transactions: [Transaction] = []
    
    // MARK: - Category Icons
    private let categoryIcons: [String: String] = [
        "Food & Drink": "cup.and.saucer.fill",
        "Shopping": "cart.fill",
        "Transport": "car.fill",
        "Bills & Utilities": "doc.text.fill",
        "Entertainment": "play.tv.fill",
        "Health": "heart.fill",
        "Other": "questionmark.circle.fill"
    ]
    
    // MARK: - Initializer
    init() {
        loadTransactionsFromRealm()
    }
    
    // MARK: - Load and map transactions
    func loadTransactionsFromRealm() {
        // Fetch all transactions from Realm using TransactionManager
        let realmTransactions = TransactionManager.getAllTransactions()
        
        // Map Realm models to Transaction struct for SwiftUI use
        self.transactions = realmTransactions.map { model in
            
            // Determine transaction type based on whether incomeAmount is > 0
            let type: TransactionType = model.incomeAmount > 0 ? .income : .expense
            
            // Choose the correct amount based on type
            let amount: Double = type == .income ? model.incomeAmount : model.expenseAmount
            
            // Determine transaction title, fallback to "Income" or "Expense" if name is empty
            let transactionTitle: String = {
                if type == .income {
                    return model.name.isEmpty ? "Income" : model.name
                } else {
                    return model.name.isEmpty ? "Expense" : model.name
                }
            }()
            
            // Determine transaction category name
            let transactionCategoryName: String = {
                if type == .income {
                    return "Good news 🎉"
                } else {
                    return model.category
                }
            }()
            
            // Determine icon name for UI
            let transactionIcon: String = {
                if type == .income {
                    return "chart.line.uptrend.xyaxis"
                } else {
                    // Use categoryIcons dictionary or fallback to a question mark
                    return categoryIcons[model.category] ?? "questionmark.circle.fill"
                }
            }()
            
            // Return a mapped Transaction struct
            return Transaction(
                title: transactionTitle,
                category: transactionCategoryName,
                amount: amount,
                time: DateHelper.formatTime(model.date),
                type: type,
                iconName: transactionIcon,
                date: DateHelper.formatDate(model.date)
            )
        }
    }
    
    // MARK: - Filtered transactions
    var filteredTransactions: [Transaction] {
        if searchText.isEmpty { return transactions }
        return transactions.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    // MARK: - Grouped transactions
    var groupedTransactions: [(key: String, value: [Transaction])] {
        let grouped = Dictionary(grouping: filteredTransactions) { $0.date }
        return grouped.sorted { $0.key > $1.key }
    }
    
}
