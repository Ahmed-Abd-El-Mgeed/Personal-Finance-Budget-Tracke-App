//
//  Validator.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 26/11/2025.
//

import Foundation

class Validator {
    
    // MARK: - Email
    static func isValidEmail(_ email: String?) -> Bool {
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines),
              !email.isEmpty else { return false }
        let emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // MARK: - Password (at least 6 chars)
    static func isValidPassword(_ password: String?) -> Bool {
        guard let password = password else { return false }
        return password.count >= 6
    }
    
    // MARK: - Website
    static func isValidWebsite(_ url: String?) -> Bool {
        guard let url = url, !url.isEmpty else { return false }
        let regex = #"^(https?:\/\/)?([\w\-]+\.)+[a-zA-Z]{2,}(\/\S*)?$"#
        return url.range(of: regex, options: .regularExpression) != nil
    }
    
    // MARK: - Date (yyyy-MM-dd or dd/MM/yyyy)
    static func isValidDate(_ date: String?) -> Bool {
        guard let date = date, !date.isEmpty else { return false }
        let df1 = DateFormatter()
        df1.locale = Locale(identifier: "en_US_POSIX")
        df1.dateFormat = "yyyy-MM-dd"
        let df2 = DateFormatter()
        df2.locale = Locale(identifier: "en_US_POSIX")
        df2.dateFormat = "dd/MM/yyyy"
        return df1.date(from: date) != nil || df2.date(from: date) != nil
    }
    
    // MARK: - Numeric (for phone, business number)
    static func isNumeric(_ text: String?) -> Bool {
        guard let text = text, !text.isEmpty else { return false }
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: text))
    }
    
    // MARK: - Postal Code (length between 4 and 10)
    static func isValidPostalCode(_ code: String?) -> Bool {
        guard let code = code, !code.isEmpty else { return false }
        return (4...10).contains(code.count)
    }
    
    // MARK: - Required Field
    static func isEmpty(_ text: String?) -> Bool {
        guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return true }
        return text.isEmpty
    }
}

