//
//  CustomButton.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 27/11/2025.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    
    let title: String
    var isEnabled: Bool = true
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isEnabled ? Color.black : Color.gray)
                .CustomCornerRadius(120, corners: [.topLeft, .bottomRight])
                .animation(.easeInOut(duration: 0.2), value: isEnabled)
        }
        .disabled(!isEnabled)
    }
}
