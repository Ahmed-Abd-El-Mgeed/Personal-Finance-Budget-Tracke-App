//
//  TransactionsData.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 01/12/2025.
//

import Foundation
import RealmSwift

class TransactionModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var type: String
    @Persisted var category: String
    @Persisted var categoryImage: String
    @Persisted var totalAmount: Double
    @Persisted var expenseAmount: Double
    @Persisted var incomeAmount: Double
    @Persisted var date: Date
    @Persisted var notes: String?
    @Persisted var receiptImageData: Data?
}
