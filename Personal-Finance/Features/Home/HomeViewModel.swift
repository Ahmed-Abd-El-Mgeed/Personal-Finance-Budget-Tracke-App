//
//  HomeViewModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 30/11/2025.
//

//import SwiftUI
//import Charts
//import Combine
//
//enum AnalyticsPeriod: String, CaseIterable {
//    case weekly = "Weekly"
//    case monthly = "Monthly"
//    case yearly = "Yearly"
//}
//
//// MARK: - Data Model
//struct ExpenseDataPoint: Identifiable {
//    let id = UUID()
//    let label: String
//    let value: Double
//}
//
//
//import SwiftUI
//import Charts
//import Combine
//import RealmSwift
//
//class HomeViewModel: ObservableObject {
//    @Published var selectedPeriod: AnalyticsPeriod = .weekly
//    @Published var selectedLabel: String?
//    @Published var showPeriodPicker = false
//    
//    // MARK: - Balance Data from Realm
//    @Published var totalBalance: String = "$0.00"
//    @Published var income: String = "$0.00"
//    @Published var expense: String = "$0.00"
//    
//    let userName = "Ahmed"
//    
//    init() {
//        updateBalances()
//    }
//    
//    // MARK: - Update balances from Realm
//    func updateBalances() {
//        let total = TransactionManager.getTotalAmount()
//        let totalIncome = TransactionManager.getTotalIncome()
//        let totalExpense = TransactionManager.getTotalExpense()
//        
//        // Format as currency strings
//        totalBalance = String(total)
//        income = String(totalIncome)
//        expense = String(totalExpense)
//    }
//    
//    private func formatCurrency(_ value: Double) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.currencySymbol = ""
//        formatter.maximumFractionDigits = 2
//        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
//    }
//    
//    // MARK: - Chart Data
//    var currentExpenseData: [ExpenseDataPoint] {
//        switch selectedPeriod {
//        case .weekly:
//            return weeklyData
//        case .monthly:
//            return monthlyData
//        case .yearly:
//            return yearlyData
//        }
//    }
//    
//    private var weeklyData: [ExpenseDataPoint] {
//        [
//            ExpenseDataPoint(label: "Tue", value: 1800),
//            ExpenseDataPoint(label: "Wed", value: 2100),
//            ExpenseDataPoint(label: "Thu", value: 2400),
//            ExpenseDataPoint(label: "Fri", value: 100),
//            ExpenseDataPoint(label: "Sat", value: 2800),
//            ExpenseDataPoint(label: "Sun", value: 2600)
//        ]
//    }
//    
//    private var monthlyData: [ExpenseDataPoint] {
//        [
//            ExpenseDataPoint(label: "Week 1", value: 8500),
//            ExpenseDataPoint(label: "Week 2", value: 9200),
//            ExpenseDataPoint(label: "Week 3", value: 7800),
//            ExpenseDataPoint(label: "Week 4", value: 10500)
//        ]
//    }
//    
//    private var yearlyData: [ExpenseDataPoint] {
//        [
//            ExpenseDataPoint(label: "Jan", value: 35000),
//            ExpenseDataPoint(label: "Feb", value: 32000),
//            ExpenseDataPoint(label: "Mar", value: 38000),
//            ExpenseDataPoint(label: "Apr", value: 36500),
//            ExpenseDataPoint(label: "May", value: 41000),
//            ExpenseDataPoint(label: "Jun", value: 39000),
//            ExpenseDataPoint(label: "Jul", value: 43000),
//            ExpenseDataPoint(label: "Aug", value: 40000),
//            ExpenseDataPoint(label: "Sep", value: 38500),
//            ExpenseDataPoint(label: "Oct", value: 42000),
//            ExpenseDataPoint(label: "Nov", value: 45000),
//            ExpenseDataPoint(label: "Dec", value: 44000)
//        ]
//    }
//    
//    func selectPeriod(_ period: AnalyticsPeriod) {
//        selectedPeriod = period
//        selectedLabel = nil
//    }
//}

//import SwiftUI
//import Charts
//import Combine
//import RealmSwift
//
//enum AnalyticsPeriod: String, CaseIterable {
//    case weekly = "Weekly"
//    case monthly = "Monthly"
//    case yearly = "Yearly"
//}
//
//// MARK: - Data Model
//struct ExpenseDataPoint: Identifiable {
//    let id = UUID()
//    let label: String
//    let value: Double
//}
//
//class HomeViewModel: ObservableObject {
//    // MARK: - Published Properties
//    @Published var selectedPeriod: AnalyticsPeriod = .weekly
//    @Published var selectedLabel: String?
//    @Published var showPeriodPicker = false
//    
//    @Published var totalBalance: String = "$0.00"
//    @Published var income: String = "$0.00"
//    @Published var expense: String = "$0.00"
//    
//    let userName = "Ahmed"
//    
//    init() {
//        updateBalances()
//    }
//    
//    // MARK: - Update Balances from Realm
//    func updateBalances() {
//        let total = TransactionManager.getTotalAmount()
//        let totalIncome = TransactionManager.getTotalIncome()
//        let totalExpense = TransactionManager.getTotalExpense()
//        
//        totalBalance = formatCurrency(total)
//        income = formatCurrency(totalIncome)
//        expense = formatCurrency(totalExpense)
//    }
//    
//    private func formatCurrency(_ value: Double) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.currencySymbol = "$"
//        formatter.maximumFractionDigits = 2
//        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
//    }
//    
//    // MARK: - Dynamic Chart Data
//    var currentExpenseData: [ExpenseDataPoint] {
//        switch selectedPeriod {
//        case .weekly:
//            return expenseDataGroupedByWeek
//        case .monthly:
//            return expenseDataGroupedByMonth
//        case .yearly:
//            return expenseDataGroupedByYear
//        }
//    }
//    
//    // MARK: - All Transaction Dates
//    var allTransactionDates: [Date] {
//        do {
//            let realm = try Realm()
//            let results = realm.objects(TransactionModel.self)
//            let dates = results.map { $0.date }
//            return Array(Set(dates)).sorted(by: { $0 < $1 })
//        } catch {
//            print("Failed to fetch transaction dates: \(error.localizedDescription)")
//            return []
//        }
//    }
//    
//    // MARK: - Helper: Grouped Chart Data
//    private var expenseDataGroupedByWeek: [ExpenseDataPoint] {
//        do {
//            let realm = try Realm()
//            let transactions = realm.objects(TransactionModel.self)
//            
//            // Group by day of the week (Sunday = 1, Monday = 2, etc.)
//            let grouped = Dictionary(grouping: transactions) { transaction in
//                Calendar.current.component(.weekday, from: transaction.date)
//            }
//            
//            let formatter = DateFormatter()
//            formatter.dateFormat = "EEE" // "Sun", "Mon", "Tue", etc.
//            
//            return grouped.map { weekday, transactions in
//                let total = transactions.reduce(0) { $0 + $1.expenseAmount }
//                
//                // Get a representative date to convert to day name
//                let firstDate = transactions.first!.date
//                return ExpenseDataPoint(label: formatter.string(from: firstDate), value: total)
//            }
//            // Sort by weekday number (Sunday = 1, Monday = 2, …)
//            .sorted { lhs, rhs in
//                let weekdays: [String: Int] = ["Sun": 1, "Mon": 2, "Tue": 3, "Wed": 4, "Thu": 5, "Fri": 6, "Sat": 7]
//                return (weekdays[lhs.label] ?? 0) < (weekdays[rhs.label] ?? 0)
//            }
//            
//        } catch {
//            print("Failed to fetch weekly expense data: \(error.localizedDescription)")
//            return []
//        }
//    }
//
//    
////    private var expenseDataGroupedByMonth: [ExpenseDataPoint] {
////        do {
////            let realm = try Realm()
////            let transactions = realm.objects(TransactionModel.self)
////            
////            // Group by month
////            let grouped = Dictionary(grouping: transactions) { transaction in
////                Calendar.current.component(.month, from: transaction.date)
////            }
////            
////            let formatter = DateFormatter()
////            formatter.dateFormat = "MMM"
////            
////            return grouped.map { month, transactions in
////                let total = transactions.reduce(0) { $0 + $1.expenseAmount }
////                let firstDate = transactions.first!.date
////                return ExpenseDataPoint(label: formatter.string(from: firstDate), value: total)
////            }.sorted(by: { $0.label < $1.label })
////        } catch {
////            print("Failed to fetch monthly expense data: \(error.localizedDescription)")
////            return []
////        }
////    }
//    
//    private var expenseDataGroupedByMonth: [ExpenseDataPoint] {
//        do {
//            let realm = try Realm()
//            let transactions = realm.objects(TransactionModel.self)
//            
//            // Group by month number (1 = Jan, 2 = Feb, …)
//            let grouped = Dictionary(grouping: transactions) { transaction in
//                Calendar.current.component(.month, from: transaction.date)
//            }
//            
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MMM" // "Jan", "Feb", "Mar", etc.
//            
//            return grouped.map { monthNumber, transactions in
//                let total = transactions.reduce(0) { $0 + $1.expenseAmount }
//                
//                // Use first transaction date to get month name
//                let firstDate = transactions.first!.date
//                return ExpenseDataPoint(label: formatter.string(from: firstDate), value: total)
//            }
//            // Sort by month number
//            .sorted { lhs, rhs in
//                let monthNumbers: [String: Int] = ["Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
//                                                   "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12]
//                return (monthNumbers[lhs.label] ?? 0) < (monthNumbers[rhs.label] ?? 0)
//            }
//            
//        } catch {
//            print("Failed to fetch monthly expense data: \(error.localizedDescription)")
//            return []
//        }
//    }
//
//    
//    private var expenseDataGroupedByYear: [ExpenseDataPoint] {
//        do {
//            let realm = try Realm()
//            let transactions = realm.objects(TransactionModel.self)
//            
//            // Group by year
//            let grouped = Dictionary(grouping: transactions) { transaction in
//                Calendar.current.component(.year, from: transaction.date)
//            }
//            
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy"
//            
//            return grouped.map { year, transactions in
//                let total = transactions.reduce(0) { $0 + $1.expenseAmount }
//                let firstDate = transactions.first!.date
//                return ExpenseDataPoint(label: formatter.string(from: firstDate), value: total)
//            }.sorted(by: { $0.label < $1.label })
//        } catch {
//            print("Failed to fetch yearly expense data: \(error.localizedDescription)")
//            return []
//        }
//    }
//    
//    // MARK: - Select Analytics Period
//    func selectPeriod(_ period: AnalyticsPeriod) {
//        selectedPeriod = period
//        selectedLabel = nil
//    }
//}


import SwiftUI
import Charts
import Combine
import RealmSwift

enum AnalyticsPeriod: String, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}

struct ExpenseDataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

class HomeViewModel: ObservableObject {
    @Published var selectedPeriod: AnalyticsPeriod = .weekly
    @Published var selectedLabel: String?
    @Published var showPeriodPicker = false
    
    @Published var totalBalance: String = "$0.00"
    @Published var income: String = "$0.00"
    @Published var expense: String = "$0.00"
    
    let userName = "Ahmed"
    
    init() {
        updateBalances()
    }
    
    func updateBalances() {
        let total = TransactionManager.getTotalAmount()
        let totalIncome = TransactionManager.getTotalIncome()
        let totalExpense = TransactionManager.getTotalExpense()
        
        totalBalance = String(total)
        income = String(totalIncome)
        expense = String(totalExpense)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    var currentExpenseData: [ExpenseDataPoint] {
        switch selectedPeriod {
        case .weekly: return expenseDataWeekly
        case .monthly: return expenseDataMonthly
        case .yearly: return expenseDataYearly
        }
    }
    
    // MARK: - weeks
    private var expenseDataWeekly: [ExpenseDataPoint] {
        let days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        var result: [ExpenseDataPoint] = []
        
        do {
            let realm = try Realm()
            let transactions = realm.objects(TransactionModel.self)
            
            for (index, dayName) in days.enumerated() {
                let weekdayNumber = index + 1
                let total = transactions
                    .filter { Calendar.current.component(.weekday, from: $0.date) == weekdayNumber }
                    .reduce(0) { $0 + $1.expenseAmount }
                
                result.append(ExpenseDataPoint(label: dayName, value: total))
            }
            
        } catch {
            print("Failed to fetch weekly data: \(error.localizedDescription)")
        }
        
        return result
    }
    
    // MARK: - Months
    private var expenseDataMonthly: [ExpenseDataPoint] {
        let months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        var result: [ExpenseDataPoint] = []
        
        do {
            let realm = try Realm()
            let transactions = realm.objects(TransactionModel.self)
            
            for (index, monthName) in months.enumerated() {
                let monthNumber = index + 1
                let total = transactions
                    .filter { Calendar.current.component(.month, from: $0.date) == monthNumber }
                    .reduce(0) { $0 + $1.expenseAmount }
                
                result.append(ExpenseDataPoint(label: monthName, value: total))
            }
            
        } catch {
            print("Failed to fetch monthly data: \(error.localizedDescription)")
        }
        
        return result
    }
    
    // MARK: - years - 3
    private var expenseDataYearly: [ExpenseDataPoint] {
        var result: [ExpenseDataPoint] = []
        
        do {
            let realm = try Realm()
            let transactions = realm.objects(TransactionModel.self)
            
            let currentYear = Calendar.current.component(.year, from: Date())
            let yearsToShow = [currentYear - 3, currentYear - 2, currentYear - 1, currentYear]
            
            for year in yearsToShow {
                let total = transactions
                    .filter { Calendar.current.component(.year, from: $0.date) == year }
                    .reduce(0) { $0 + $1.expenseAmount }
                
                result.append(ExpenseDataPoint(label: "\(year)", value: total))
            }
            
        } catch {
            print("Failed to fetch yearly data: \(error.localizedDescription)")
        }
        
        return result
    }

    
    func selectPeriod(_ period: AnalyticsPeriod) {
        selectedPeriod = period
        selectedLabel = nil
    }
}
