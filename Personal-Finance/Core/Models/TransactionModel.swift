//
//  TransactionModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 09/12/2025.
//

import Foundation


// MARK: - Transaction Model for UI
struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let amount: Double
    let time: String
    let type: TransactionType
    let iconName: String
    let date: String
}

// MARK: - Transaction Type
enum TransactionType {
    case expense, income
}
