//
//  HomeView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 20/11/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightBeige.ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        headerSection
                        balanceCardSection
                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationBarHidden(true)
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
                Text("Ahmed")
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
                .foregroundColor(.white.opacity(0.7))
            Text("$24,562.00")
                .font(.system(size: 36, weight: .bold))
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
                    Text("$4,250")
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
                    Text("$1,890")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}



