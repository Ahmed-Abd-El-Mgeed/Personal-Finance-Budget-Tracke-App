//
//  AddViewModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 30/11/2025.
//

import Foundation
import Combine
import SwiftUI
import RealmSwift

class AddViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var startAmount: String = "0.00"
    @Published var expenseAmount: String = "0.00"
    @Published var incomeAmount: String = "0.00"
    @Published var isExpense: Bool = true
    @Published var selectedCategory: String = "Food & Drink"
    @Published var selectedDate: Date = Date()
    @Published var name: String = ""
    @Published var selectedImage: UIImage?
    @Published var hasAttachment: Bool = false
    
    let categories = [
        "Food & Drink", "Shopping", "Transport",
        "Bills & Utilities", "Entertainment",
        "Health", "Other"
    ]
    
    init() {
        // Initialize amount with startAmount
        updateCurrentAmount()
    }
    
    // MARK: - Update amount based on type
    func updateCurrentAmount() {
        if isExpense {
            expenseAmount = startAmount
        } else {
            incomeAmount = startAmount
        }
    }
    
    // MARK: - Amount Actions
    func incrementAmount() {
        if isExpense {
            if let value = Double(expenseAmount) {
                expenseAmount = String(format: "%.2f", value + 1)
            }
        } else {
            if let value = Double(incomeAmount) {
                incomeAmount = String(format: "%.2f", value + 1)
            }
        }
    }
    
    func decrementAmount() {
        if isExpense {
            if let value = Double(expenseAmount), value > 0 {
                expenseAmount = String(format: "%.2f", max(0, value - 1))
            }
        } else {
            if let value = Double(incomeAmount), value > 0 {
                incomeAmount = String(format: "%.2f", max(0, value - 1))
            }
        }
    }
    
    // MARK: - Toggle Type
    func setExpense() {
        isExpense = true
        updateCurrentAmount()
    }
    
    func setIncome() {
        isExpense = false
        updateCurrentAmount()
    }
    
    // MARK: - Save Transaction to Realm
    func saveTransaction() {
        let expense = isExpense ? Double(expenseAmount) ?? 0 : 0
        let income = isExpense ? 0 : Double(incomeAmount) ?? 0
        
        guard expense > 0 || income > 0 else {
            print("Amount must be greater than 0")
            return
        }
        
        let realm = try! Realm()
        
        let transaction = TransactionModel()
        transaction.name = name
        transaction.type = isExpense ? "Expense" : "Income"
        transaction.category = selectedCategory
        transaction.categoryImage = "" // optional: set icon/image name
        transaction.expenseAmount = expense
        transaction.incomeAmount = income
        transaction.date = selectedDate
        transaction.notes = name.isEmpty ? nil : name
        if let image = selectedImage {
            transaction.receiptImageData = image.jpegData(compressionQuality: 0.8)
        }
        
        do {
            try realm.write {
                realm.add(transaction)
            }
            print("Transaction saved successfully! \(transaction)")
            resetForm()
        } catch {
            print("Error saving transaction:", error.localizedDescription)
        }
    }
    
    // MARK: - Reset Form
    private func resetForm() {
        startAmount = "0.00"
        expenseAmount = "0.00"
        incomeAmount = "0.00"
        isExpense = true
        selectedCategory = categories.first ?? "Other"
        selectedDate = Date()
        name = ""
        selectedImage = nil
        hasAttachment = false
    }
}
