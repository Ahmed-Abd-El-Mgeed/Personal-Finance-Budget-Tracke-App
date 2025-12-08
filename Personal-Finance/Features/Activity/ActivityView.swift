//
//  ActivityView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 30/11/2025.
//

import SwiftUI

struct ActivityView: View {
    @State private var searchText = ""
    @State private var showFilter = false
    
    var body: some View {
        MobileWrapper {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 24) {
                    // Navigation Bar
                    HStack {
                        HStack(spacing: 16) {
                            NavigationLink(destination: HomeView()) {
                                Circle()
                                    .fill(Color.card)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(.primary)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(Color.border, lineWidth: 1)
                                    )
                            }
                            
                            Text("Transactions")
                                .font(.system(size: 20, weight: .bold))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showFilter.toggle()
                        }) {
                            Circle()
                                .fill(Color.card)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "line.3.horizontal.decrease.circle")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.primary)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.border, lineWidth: 1)
                                )
                        }
                    }
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundColor(.secondary)
                            .padding(.leading, 16)
                        
                        TextField("Search transactions...", text: $searchText)
                            .font(.system(size: 16))
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
                }
                .padding(.horizontal, 24)
                .padding(.top, 48)
                .padding(.bottom, 24)
                .background(Color.background)
                .zIndex(1)
                
                // Transactions List
                ScrollView {
                    LazyVStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Today")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 12) {
                                TransactionItem(
                                    title: "Apple Store",
                                    category: "Electronics",
                                    amount: 1299.00,
                                    time: "10:42 AM",
                                    type: .expense,
                                    iconName: "cart.fill"
                                )
                                
                                TransactionItem(
                                    title: "Starbucks",
                                    category: "Food & Drink",
                                    amount: 5.40,
                                    time: "08:15 AM",
                                    type: .expense,
                                    iconName: "cup.and.saucer.fill"
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Yesterday")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 12) {
                                TransactionItem(
                                    title: "Uber Trip",
                                    category: "Transport",
                                    amount: 24.50,
                                    time: "8:30 PM",
                                    type: .expense,
                                    iconName: "car.fill"
                                )
                                
                                TransactionItem(
                                    title: "Freelance Work",
                                    category: "Design",
                                    amount: 850.00,
                                    time: "4:15 PM",
                                    type: .income,
                                    iconName: "paintbrush.fill"
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("October 24")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 12) {
                                TransactionItem(
                                    title: "Whole Foods",
                                    category: "Groceries",
                                    amount: 142.80,
                                    time: "12:20 PM",
                                    type: .expense,
                                    iconName: "bag.fill"
                                )
                                
                                TransactionItem(
                                    title: "Netflix Subscription",
                                    category: "Entertainment",
                                    amount: 15.99,
                                    time: "09:00 AM",
                                    type: .expense,
                                    iconName: "play.tv.fill"
                                )
                                
                                TransactionItem(
                                    title: "Gas Station",
                                    category: "Transport",
                                    amount: 45.00,
                                    time: "07:30 AM",
                                    type: .expense,
                                    iconName: "fuelpump.fill"
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 96)
                }
            }
            .sheet(isPresented: $showFilter) {
                FilterView()
            }
            
            
        }
    }
}

// Transaction Item Component
struct TransactionItem: View {
    let title: String
    let category: String
    let amount: Double
    let time: String
    let type: TransactionType
    let iconName: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Container
            Circle()
                .fill(Color.card)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: iconName)
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                )
            
            // Transaction Details
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                
                Text(category)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount and Time
            VStack(alignment: .trailing, spacing: 4) {
                Text(type == .expense ? "-$\(amount, specifier: "%.2f")" : "+$\(amount, specifier: "%.2f")")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(type == .expense ? .expenseRed : .incomeGreen)
                
                Text(time)
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

enum TransactionType {
    case expense, income
}

// Color Extensions
extension Color {
    static let background = Color("Background")
    static let card = Color("Card")
    static let border = Color("Border")
    static let expenseRed = Color.red
    static let incomeGreen = Color.green
}

// Filter View (placeholder)
struct FilterView: View {
    var body: some View {
        NavigationView {
            Text("Filter Options")
                .navigationTitle("Filter")
                .navigationBarItems(trailing: Button("Done") {})
        }
    }
}



// Mobile Wrapper
struct MobileWrapper<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.background
                    .edgesIgnoringSafeArea(.all)
                
                content
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ActivityView()
}


