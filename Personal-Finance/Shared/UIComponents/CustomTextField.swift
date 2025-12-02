//
//  CustomTextField.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 27/11/2025.
//

import Foundation
import SwiftUI

// MARK: - Reusable Text Field
struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var isSecure: Bool = false
    var error: String = ""
    var systemImage: String
    var toggleSecure: (() -> Void)? = nil
    var isSecureToggleVisible: Bool = false
    var isSecureOn: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
                
                if isSecure {
                    SecureField("Enter your \(title.lowercased())", text: $text)
                        .padding()
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                } else {
                    TextField("Enter your \(title.lowercased())", text: $text)
                        .padding()
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                
                if isSecureToggleVisible, let toggleSecure = toggleSecure {
                    Button(action: toggleSecure) {
                        Image(systemName: isSecureOn ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 12)
                } else if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 12)
                }
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(error.isEmpty ? Color.gray.opacity(0.3) : Color.red, lineWidth: 1)
            )
            
            if !error.isEmpty {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}
