//
//  LoginViewModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 26/11/2025.
//

import SwiftUI
import Combine
import FirebaseAuth


// MARK: - LoginViewModel
class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var emailError = ""
    
    
    @Published var password = ""
    @Published var passwordError = ""
    @Published var isPasswordVisible = false
    
    @Published var loginError = ""
    @Published var isLoading = false
    
    
    // Background animation
    @Published var dollars: [RandomDollar] = (0..<120).map { _ in
        RandomDollar(
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 12...22),
            opacity: Double.random(in: 0.2...0.6)
        )
    }
    
    // MARK: - Validation
    func validateEmailLive() {
        if Validator.isEmpty(email) {
            emailError = "Email is required"
        } else if !Validator.isValidEmail(email) {
            emailError = "Invalid email format"
        } else {
            emailError = ""
        }
    }
    
    func validatePasswordLive() {
        if Validator.isEmpty(password) {
            passwordError = "Password is required"
        } else if !Validator.isValidPassword(password) {
            passwordError = "Password must be at least 6 characters"
        } else {
            passwordError = ""
        }
    }
    
    func validate() -> Bool {
        validateEmailLive()
        validatePasswordLive()
        return emailError.isEmpty && passwordError.isEmpty
    }
    
    var isFormValid: Bool {
          !email.isEmpty &&
          Validator.isValidEmail(email) &&
          !password.isEmpty &&
          Validator.isValidPassword(password)
      }
    
    // MARK: - Firebase Login
    func login(completion: @escaping (Bool) -> Void) {
        guard validate() else {
            completion(false)
            return
        }
        
        isLoading = true
        loginError = ""
        
        
        LoginService.shared.login(email: email, password: password) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success:
                DefaultManager.setLoggedIn(true)
                completion(true)
            case .failure(let error):
                self?.loginError = error.localizedDescription
                completion(false)
            }
        }
    }
}
