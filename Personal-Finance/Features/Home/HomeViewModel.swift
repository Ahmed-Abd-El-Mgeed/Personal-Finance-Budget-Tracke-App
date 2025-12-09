//
//  HomeViewModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 30/11/2025.
//

import SwiftUI
import Charts
import Combine
import RealmSwift
import Realm


class HomeViewModel: ObservableObject {
    @Published var selectedPeriod: AnalyticsPeriod = .weekly
    @Published var selectedLabel: String?
    @Published var showPeriodPicker = false
    
    @Published var totalBalance: String = "$0.00"
    @Published var income: String = "$0.00"
    @Published var expense: String = "$0.00"
    
    let userName = "Ahmed"
    
    private var notificationToken: NotificationToken?
    
    init() {
        updateBalances()
        observeRealmChanges()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    private func observeRealmChanges() {
        do {
            let realm = try Realm()
            let transactions = realm.objects(TransactionModel.self)
            
            notificationToken = transactions.observe { [weak self] _ in
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                    self?.updateBalances()
                }
            }
        } catch {
            print("Failed to observe Realm changes: \(error)")
        }
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
    
    // MARK: - weeks (Current Week Only)
    private var expenseDataWeekly: [ExpenseDataPoint] {
        let days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        var result: [ExpenseDataPoint] = []
        
        do {
            let realm = try Realm()
            let transactions = realm.objects(TransactionModel.self)
            
            // Get current week's start and end dates
            let calendar = Calendar.current
            let today = Date()
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else {
                return []
            }
            
            let startOfWeek = weekInterval.start
            let endOfWeek = weekInterval.end
            
            for (index, dayName) in days.enumerated() {
                let weekdayNumber = index + 1
                let total = transactions
                    .filter {
                        let transactionDate = $0.date
                        return transactionDate >= startOfWeek &&
                               transactionDate < endOfWeek &&
                               calendar.component(.weekday, from: transactionDate) == weekdayNumber
                    }
                    .reduce(0) { $0 + $1.expenseAmount }
                
                result.append(ExpenseDataPoint(label: dayName, value: total))
            }
            
        } catch {
            print("Failed to fetch weekly data: \(error.localizedDescription)")
        }
        
        return result
    }
    
    // MARK: - Months (Current Year Only)
    private var expenseDataMonthly: [ExpenseDataPoint] {
        let months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        var result: [ExpenseDataPoint] = []
        
        do {
            let realm = try Realm()
            let transactions = realm.objects(TransactionModel.self)
            
            let currentYear = Calendar.current.component(.year, from: Date())
            
            for (index, monthName) in months.enumerated() {
                let monthNumber = index + 1
                let total = transactions
                    .filter {
                        let year = Calendar.current.component(.year, from: $0.date)
                        let month = Calendar.current.component(.month, from: $0.date)
                        return year == currentYear && month == monthNumber
                    }
                    .reduce(0) { $0 + $1.expenseAmount }
                
                result.append(ExpenseDataPoint(label: monthName, value: total))
            }
            
        } catch {
            print("Failed to fetch monthly data: \(error.localizedDescription)")
        }
        
        return result
    }
    
    // MARK: - years - Last 4 Years
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
