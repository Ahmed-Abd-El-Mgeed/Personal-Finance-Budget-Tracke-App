//
//  DefaultManager.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 25/11/2025.
//

import Foundation

// MARK: - UserDefaults Manager
class DefaultManager {
    
    // MARK: - Keys
    private enum Keys {
        static let isOnBoardingSeen = "isOnBoardingSeen"
        static let lang = "app_language"
        static let isLoggedIn = "isLoggedIn"
        static let userEmail = "userEmail"
        static let rememberMe = "rememberMe"
        static let faceIDEnabled = "faceIDEnabled"
        static let appleLogin = "appleLogin"
    }
    
    
    // MARK: - OnBoarding
    static func setOnBoardingSeen() {
        UserDefaults.standard.set(true, forKey: Keys.isOnBoardingSeen)
    }
    static func isOnBoardingSeen() -> Bool {
        UserDefaults.standard.bool(forKey: Keys.isOnBoardingSeen)
    }
    
    
    // MARK: - Language
    static func saveUserLang(_ language: String) {
        UserDefaults.standard.set(language, forKey: Keys.lang)
    }
    static func getUserLang() -> String? {
        UserDefaults.standard.string(forKey: Keys.lang)
    }
    
    
    // MARK: - Login State
    static func setLoggedIn(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.isLoggedIn)
    }
    static func isLoggedIn() -> Bool {
        UserDefaults.standard.bool(forKey: Keys.isLoggedIn)
    }
    
    
    // MARK: - User Email
    static func saveUserEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: Keys.userEmail)
    }
    static func getUserEmail() -> String? {
        UserDefaults.standard.string(forKey: Keys.userEmail)
    }
    
    
    // MARK: - Remember Me
    static func setRememberMe(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.rememberMe)
    }
    static func isRememberMeEnabled() -> Bool {
        UserDefaults.standard.bool(forKey: Keys.rememberMe)
    }
    
    
    // MARK: - Face ID Login
    static func setFaceIDEnabled(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.faceIDEnabled)
    }
    static func isFaceIDEnabled() -> Bool {
        UserDefaults.standard.bool(forKey: Keys.faceIDEnabled)
    }
    
    
    // MARK: - Apple Login
    static func setAppleLogin(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.appleLogin)
    }
    static func isAppleLoggedIn() -> Bool {
        UserDefaults.standard.bool(forKey: Keys.appleLogin)
    }
}

