//
//  HomeView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 20/11/2025.
//

import SwiftUI
import Charts

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightBeige.ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        headerSection
                        balanceCardSection
                        analyticsSection
                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                loadData()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            profilePicture
            welcomeText
            Spacer()
            actionButtons
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    // MARK: - Profile Picture
    private var profilePicture: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 50, height: 50)
            .overlay(
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
            )
    }
    
    // MARK: - Welcome Text
    private var welcomeText: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Welcome back,")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(viewModel.userName)
                .font(.title2)
                .fontWeight(.bold)
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack(spacing: 15) {
            Button(action: {}) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell.fill")
                        .font(.title3)
                        .foregroundColor(.black)
                        .frame(width: 45, height: 45)
                        .background(Color.white)
                        .clipShape(Circle())
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .offset(x: -8, y: 8)
                }
            }
        }
    }
    
    // MARK: - Balance Card Section
    private var balanceCardSection: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.13))
                    .frame(height: 220)
                
                VStack(spacing: 25) {
                    totalBalanceView
                    incomeExpenseRow
                }
                .padding(25)
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Total Balance View
    private var totalBalanceView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Total Balance")
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))
            Text(viewModel.totalBalance)
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: - Income Expense Row
    private var incomeExpenseRow: some View {
        HStack(spacing: 0) {
            incomeView
            
            Rectangle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 1, height: 40)
                .padding(.horizontal, 15)
            
            expenseView
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Income View
    private var incomeView: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.9))
                    .frame(width: 40, height: 40)
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Income")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(viewModel.income)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
    }
    
    // MARK: - Expense View
    private var expenseView: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.9))
                    .frame(width: 40, height: 40)
                Image(systemName: "chart.line.downtrend.xyaxis")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Expense")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(viewModel.expense)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
    }
    
    // MARK: - Analytics Section
    private var analyticsSection: some View {
        VStack(spacing: 0) {
            analyticsHeader
            chartCard
        }
    }
    
    // MARK: - Analytics Header
    private var analyticsHeader: some View {
        HStack {
            Text("Analytics")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            periodPickerButton
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 15)
    }
    
    // MARK: - Period Picker Button
    private var periodPickerButton: some View {
        Button(action: {
            viewModel.showPeriodPicker.toggle()
        }) {
            HStack(spacing: 5) {
                Text(viewModel.selectedPeriod.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .actionSheet(isPresented: $viewModel.showPeriodPicker) {
            ActionSheet(
                title: Text("Select Period"),
                buttons: AnalyticsPeriod.allCases.map { period in
                        .default(Text(period.rawValue)) {
                            viewModel.selectPeriod(period)
                        }
                } + [.cancel()]
            )
        }
    }
    
    // MARK: - Chart Card
    private var chartCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 20) {
                chartLegend
                ExpenseLineChart(
                    data: viewModel.currentExpenseData,
                    selectedLabel: $viewModel.selectedLabel
                )
                
            }
            .padding(25)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Chart Legend
    private var chartLegend: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.black)
                .frame(width: 10, height: 10)
            Text("Expenses")
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}
// MARK: - Actions
extension HomeView {
    private func loadData() {
        viewModel.updateBalances()
        let transactions = TransactionManager.getAllTransactions()
        print("ALLData\(transactions)")
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}

