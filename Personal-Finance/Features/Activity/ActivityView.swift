//
//  ActivityView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 30/11/2025.
//

import SwiftUI

// MARK: - Colors
extension Color {
    static let background = Color("Background")
    static let card = Color("Card")
    static let border = Color("Border")
    static let expenseRed = Color.red
    static let incomeGreen = Color.green
}

// MARK: - Activity View
struct ActivityView: View {
    @StateObject private var viewModel = ActivityViewModel()
    
    var body: some View {
        MobileWrapper {
            VStack(spacing: 0) {
                
                // Header
                VStack(spacing: 16) {
                    Text("Transactions")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)
                    
                    // Search + Filter
                    HStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                                .padding(.leading, 16)
                            
                            TextField("Search transactions...", text: $viewModel.searchText)
                                .padding(.vertical, 12)
                                .padding(.trailing, 16)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.border, lineWidth: 1)
                                )
                        )
                        .frame(height: 48)
                        
                        Button(action: { viewModel.showFilter.toggle() }) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.primary)
                                .padding()
                                .background(
                                    Circle()
                                        .fill(Color.card)
                                        .overlay(Circle().stroke(Color.border, lineWidth: 1))
                                )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 48)
                .padding(.bottom, 16)
                .background(Color.background)
                .zIndex(1)
                
                // Transactions List
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [.sectionHeaders]) {
                        ForEach(viewModel.groupedTransactions, id: \.key) { date, items in
                            Section(
                                header: Text(date)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 24)
                                    .padding(.top, 8)
                            ) {
                                ForEach(items) { transaction in
                                    TransactionItem(transaction: transaction)
                                        .padding(.horizontal, 24)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 96)
                }
            }
            .sheet(isPresented: $viewModel.showFilter) {
                FilterView()
            }
        }
    }
}

// MARK: - Transaction Item
struct TransactionItem: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.card)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: transaction.iconName)
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.system(size: 16, weight: .medium))
                Text(transaction.category)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.type == .expense
                     ? "-$\(transaction.amount, specifier: "%.2f")"
                     : "+$\(transaction.amount, specifier: "%.2f")")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(transaction.type == .expense ? .expenseRed : .incomeGreen)
                
                Text(transaction.time)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.card)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.border, lineWidth: 1)
        )
    }
}

// MARK: - Filter View
struct FilterView: View {
    var body: some View {
        NavigationView {
            Text("Filter Options")
                .navigationTitle("Filter")
                .navigationBarItems(trailing: Button("Done") {})
        }
    }
}

// MARK: - Mobile Wrapper
struct MobileWrapper<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                content
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
#Preview {
    ActivityView()
}
