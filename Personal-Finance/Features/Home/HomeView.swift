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
                viewModel.updateBalances()
                let transactions = TransactionManager.getAllTransactions()
                print("ALLData\(transactions)")

            }
        }
    }
}

// MARK: - Private Views
private extension HomeView {
    
    var headerSection: some View {
        HStack {
            // Profile Picture
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                )
            
            // Welcome Text
            VStack(alignment: .leading, spacing: 2) {
                Text("Welcome back,")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(viewModel.userName)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            // Action Buttons
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
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    var balanceCardSection: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.13))
                    .frame(height: 220)
                
                VStack(spacing: 25) {
                    totalBalance
                    incomeExpenseRow
                }
                .padding(25)
            }
        }
        .padding(.horizontal, 20)
    }
    
    var totalBalance: some View {
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
    
    var incomeExpenseRow: some View {
        HStack(spacing: 0) {
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
            
            Rectangle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 1, height: 40)
                .padding(.horizontal, 15)
            
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
        .frame(maxWidth: .infinity)
    }
    
    var analyticsSection: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Analytics")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Period Picker Button
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
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 15)
            
            // Chart Card
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Legend
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 10, height: 10)
                        Text("Expenses")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                    // Chart
                    Chart(viewModel.currentExpenseData) { item in
                        LineMark(
                            x: .value("Period", item.label),
                            y: .value("Value", item.value)
                        )
                        .foregroundStyle(Color.black)
                        .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Period", item.label),
                            y: .value("Value", item.value)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.clear]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                        
                        if let selectedLabel = viewModel.selectedLabel, selectedLabel == item.label {
                            PointMark(
                                x: .value("Period", item.label),
                                y: .value("Value", item.value)
                            )
                            .foregroundStyle(Color.black)
                            .symbolSize(100)
                            
                            RuleMark(x: .value("Period", item.label))
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                                .foregroundStyle(Color.gray.opacity(0.5))
                                .annotation(position: .bottom, spacing: 10) {
                                    VStack(spacing: 5) {
                                        Text(item.label)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        Text("value : \(Int(item.value))")
                                            .font(.subheadline)
                                    }
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                }
                        }
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .automatic) { value in
                            if let label = value.as(String.self) {
                                AxisValueLabel {
                                    Text(label)
                                        .font(.caption)
                                        .foregroundStyle(viewModel.selectedLabel == label ? Color.black : Color.gray)
                                        .fontWeight(viewModel.selectedLabel == label ? .semibold : .regular)
                                        .onTapGesture {
                                            viewModel.selectedLabel = label
                                        }
                                }
                            }
                        }
                    }
                    .chartYAxis(.hidden)
                    .chartXSelection(value: $viewModel.selectedLabel)
                }
                .padding(25)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}

