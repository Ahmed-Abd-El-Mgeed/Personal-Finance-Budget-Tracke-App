//
//  RegisterService.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 27/11/2025.
//

import Foundation
import FirebaseAuth

/// Service class to handle user registration with Firebase
class RegisterService {
    
    init() {}
    
    /// Register a new user with email, password, and display name
    func register(email: String, password: String, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Create user in Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let user = authResult?.user else {
                    completion(.failure(NSError(domain: "RegisterService", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                    return
                }
                
                // Update the user's display name
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    // Optional: Send email verification
                    user.sendEmailVerification(completion: nil)
                    
                    completion(.success(()))
                }
            }
        }
    }
}

