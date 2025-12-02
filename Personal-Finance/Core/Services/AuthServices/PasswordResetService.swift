//
//  PasswordResetService.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 27/11/2025.
//

import Foundation
import FirebaseAuth

/// Service class to handle password reset via Firebase
class PasswordResetService {
    
    init() {}
    
    /// Send a password reset email to the given email address
    func sendPasswordReset(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}
