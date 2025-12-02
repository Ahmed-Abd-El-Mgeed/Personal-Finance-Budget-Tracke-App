//
//  AddView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 30/11/2025.
//

import SwiftUI
import PhotosUI

struct AddView: View {
    @StateObject private var viewModel = AddViewModel()
    @State private var showingDatePicker = false
    @State private var showingImagePicker = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.lightBeige.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Text("Add Transaction")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        
                        // MARK: Amount
                        VStack(spacing: 8) {
                            Text("Amount")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .padding(.bottom, 4)
                            
                            HStack(spacing: 20) {
                                
                                // $ Symbol
                                Text("$")
                                    .font(.system(size: 44, weight: .bold))
                                    .foregroundColor(Color.black.opacity(0.9))
                                
                                // Amount TextField
                                ZStack {
                                    TextField("0.00", text: viewModel.isExpense ? $viewModel.expenseAmount : $viewModel.incomeAmount)
                                        .font(.system(size: 56, weight: .bold))
                                        .keyboardType(.decimalPad)
                                        .foregroundColor(Color.black.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(minWidth: 140)
                                
                                // Vertical Divider
                                Rectangle()
                                    .fill(Color.black.opacity(0.15))
                                    .frame(width: 1, height: 60)
                                
                                // Up/Down Stepper Buttons
                                VStack(spacing: 0) {
                                    Button {
                                        viewModel.incrementAmount()
                                    } label: {
                                        Image(systemName: "chevron.up")
                                            .font(.system(size: 16, weight: .bold))
                                            .padding(.vertical, 8)
                                    }
                                    
                                    Divider()
                                        .frame(width: 24)
                                    
                                    Button {
                                        viewModel.decrementAmount()
                                    } label: {
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 16, weight: .bold))
                                            .padding(.vertical, 8)
                                    }
                                }
                                .frame(width: 55, height: 70)
                                .background(Color.black.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                        }
                        .padding(.vertical, 20)
                        
                        // MARK: Type
                        HStack(spacing: 0) {
                            toggleButton(title: "Expense", isSelected: viewModel.isExpense) {
                                viewModel.setExpense()
                            }
                            
                            toggleButton(title: "Income", isSelected: !viewModel.isExpense) {
                                viewModel.setIncome()
                            }
                        }
                        .padding(6)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color(.separator), lineWidth: 1)
                        )
                        .cornerRadius(18)
                        
                        // MARK: Form Card
                        VStack(spacing: 0) {
                            if viewModel.isExpense {
                                
                                formRow(
                                    icon: "doc.text",
                                    iconColor: .purple,
                                    title: "Name",
                                    content: {
                                        TextField("Add a Transaction Name ...", text: $viewModel.name)
                                    }
                                )
                                
                                Divider()
                                
                                formRow(
                                    icon: "tag",
                                    iconColor: .orange,
                                    title: "Category",
                                    content: {
                                        Picker("", selection: $viewModel.selectedCategory) {
                                            ForEach(viewModel.categories, id: \.self) { cat in
                                                Text(cat).tag(cat)
                                            }
                                        }
                                        .tint(.black)
                                    }
                                )
                                
                                Divider()
                                
                                formRow(
                                    icon: "calendar",
                                    iconColor: .blue,
                                    title: "Date",
                                    content: {
                                        Button {
                                            showingDatePicker.toggle()
                                        } label: {
                                            HStack {
                                                Text(viewModel.selectedDate, style: .date)
                                                    .font(.system(size: 16, weight: .semibold))
                                                Spacer()
                                            }
                                        }
                                    }
                                )
                                
                                Divider()
                                
                                formRow(
                                    icon: "camera",
                                    iconColor: .gray,
                                    title: "Receipt",
                                    content: {
                                        Button {
                                            showingImagePicker.toggle()
                                        } label: {
                                            Text(viewModel.hasAttachment ? "✓ Receipt Added" : "Add Receipt")
                                                .foregroundColor(viewModel.hasAttachment ? .green : .blue)
                                                .fontWeight(.semibold)
                                        }
                                    }
                                )
                                
                            } else {
                                // Income → only Date
                                formRow(
                                    icon: "calendar",
                                    iconColor: .blue,
                                    title: "Date",
                                    content: {
                                        Button {
                                            showingDatePicker.toggle()
                                        } label: {
                                            HStack {
                                                Text(viewModel.selectedDate, style: .date)
                                                    .font(.system(size: 16, weight: .semibold))
                                                Spacer()
                                            }
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.vertical, 4)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.separator), lineWidth: 1)
                        )
                        
                        // MARK: Save Button
                        Button {
                            viewModel.saveTransaction()
                        } label: {
                            Text("Save Transaction")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.black)
                                .cornerRadius(12)
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 22)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingDatePicker) {
                DatePickerSheet(
                    selectedDate: $viewModel.selectedDate,
                    isPresented: $showingDatePicker
                )
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(
                    selectedImage: $viewModel.selectedImage,
                    hasAttachment: $viewModel.hasAttachment
                )
            }
        }
    }
}

// MARK: - Toggle Button Component
func toggleButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(isSelected ? .white : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.black : Color.clear)
            .cornerRadius(15)
    }
}

// MARK: - Form Row Component
func formRow(icon: String, iconColor: Color, title: String, @ViewBuilder content: () -> some View) -> some View {
    HStack(spacing: 14) {
        ZStack {
            Circle()
                .fill(iconColor.opacity(0.2))
                .frame(width: 44, height: 44)
            
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
        }
        
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            content()
                .font(.system(size: 16, weight: .semibold))
        }
        
        Spacer()
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
}

#Preview {
    AddView()
}


