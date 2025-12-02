//
//  SignUpViewModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 27/11/2025.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth

// MARK: - SignUpViewModel
class SignUpViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var userName = ""
    @Published var userNameError = ""
    
    @Published var email = ""
    @Published var emailError = ""
    
    @Published var password = ""
    @Published var passwordError = ""
    
    @Published var confirmPassword = ""
    @Published var confirmError = ""
    
    @Published var isPasswordVisible = false
    @Published var isConfirmPasswordVisible = false
    @Published var isLoading = false
    @Published var signUpError = ""
    
    // Background animation
    @Published var dollars: [RandomDollar] = (0..<200).map { _ in
        RandomDollar(
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 12...22),
            opacity: Double.random(in: 0.2...0.6)
        )
    }
    
    // MARK: - Validation Methods
    func validateUserNameLive() {
        if Validator.isEmpty(userName) {
            userNameError = "Username is required"
        } else {
            userNameError = ""
        }
    }
    
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
    
    func validateConfirmPasswordLive() {
        if Validator.isEmpty(confirmPassword) {
            confirmError = "Confirm password is required"
        } else if confirmPassword != password {
            confirmError = "Passwords do not match"
        } else {
            confirmError = ""
        }
    }
    
    // MARK: - Full Validation
    func validate() -> Bool {
        validateUserNameLive()
        validateEmailLive()
        validatePasswordLive()
        validateConfirmPasswordLive()
        
        return userNameError.isEmpty &&
        emailError.isEmpty &&
        passwordError.isEmpty &&
        confirmError.isEmpty
    }
    
    var isFormValid: Bool {
        !userName.isEmpty &&
        !email.isEmpty &&
        Validator.isValidEmail(email) &&
        !password.isEmpty &&
        Validator.isValidPassword(password) &&
        !confirmPassword.isEmpty &&
        confirmPassword == password
    }
    
    // MARK: - Firebase Sign Up
    func signUp(completion: @escaping (Bool) -> Void) {
        // Validate fields first
        guard validate() else {
            completion(false)
            return
        }
        
        isLoading = true
        signUpError = ""
        
        // Call the register service
        RegisterService().register(email: email, password: password, name: userName) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    completion(true)
                    
                case .failure(let error):
                    self?.signUpError = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
}
