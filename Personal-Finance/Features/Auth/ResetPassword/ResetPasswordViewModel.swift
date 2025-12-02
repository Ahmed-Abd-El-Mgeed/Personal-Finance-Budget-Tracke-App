//
//  ResetPasswordViewModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 27/11/2025.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth


// MARK: - ResetPasswordViewModel
class ResetPasswordViewModel: ObservableObject {
    
    // Background animation
    @Published var dollars: [RandomDollar] = (0..<120).map { _ in
        RandomDollar(
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 12...22),
            opacity: Double.random(in: 0.2...0.6)
        )
    }
    
}
