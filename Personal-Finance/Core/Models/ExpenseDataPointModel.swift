//
//  ExpenseDataPointModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 09/12/2025.
//

import Foundation

struct ExpenseDataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}
