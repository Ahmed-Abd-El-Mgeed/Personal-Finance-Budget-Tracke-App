//
//  TransactionManager.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 01/12/2025.
//

import Foundation
import Foundation
import RealmSwift

class TransactionManager {
    
    // MARK: - Fetch all transactions
    static func getAllTransactions() -> [TransactionModel] {
        do {
            let realm = try Realm()
            let results = realm.objects(TransactionModel.self)
            return Array(results)
        } catch let error {
            print("Failed to fetch transactions: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Total amount (income + expense)
    static func getTotalAmount() -> Double {
        let transactions = getAllTransactions()
        return transactions.reduce(0) { $0 + $1.incomeAmount + $1.expenseAmount }
    }
    
    // MARK: - Total expense
    static func getTotalExpense() -> Double {
        let transactions = getAllTransactions()
        return transactions.reduce(0) { $0 + $1.expenseAmount }
    }
    
    // MARK: - Total income
    static func getTotalIncome() -> Double {
        let transactions = getAllTransactions()
        return transactions.reduce(0) { $0 + $1.incomeAmount }
    }
    
    // MARK: - Clear all transactions
       static func clearAllTransactions() {
           do {
               let realm = try Realm()
               try realm.write {
                   let allTransactions = realm.objects(TransactionModel.self)
                   realm.delete(allTransactions)
               }
               print("All transactions cleared successfully.")
           } catch let error {
               print("Failed to clear transactions: \(error.localizedDescription)")
           }
       }
}
