//
//  LoginService.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 27/11/2025.
//

import Foundation
import FirebaseAuth

class LoginService {
    
    static let shared = LoginService() 
    
    private init() {}
    
    /// Perform login using Firebase
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
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

