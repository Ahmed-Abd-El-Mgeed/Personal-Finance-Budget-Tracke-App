//
//  AppFlowViewModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 25/11/2025.
//

import Foundation
import SwiftUI
import Combine

class SplashFlowViewModel: ObservableObject {
    @Published var state: AppState = .splash
    
    init() {
        startSplashTimer()
    }

    private func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.loadState()
        }
    }

    private func loadState() {
        if DefaultManager.isOnBoardingSeen() == false {
            state = .onboarding
        } else if DefaultManager.isLoggedIn() == false {
            state = .login
        } else {
            state = .login
        }
    }

    func completeOnboarding() {
        DefaultManager.setOnBoardingSeen()
        state = .login
    }

    func login() {
        DefaultManager.setLoggedIn(true)
        state = .home
    }

    func logout() {
        DefaultManager.setLoggedIn(false)
        state = .login
    }
}

enum AppState {
    case splash
    case onboarding
    case login
    case home
}
