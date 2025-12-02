//
//  RootView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 20/11/2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var flow: SplashFlowViewModel
    
    var body: some View {
        switch flow.state {
        case .splash: SplashView()
        case .onboarding: OnboardingView()
        case .login: LoginView()
        case .home: TabBarView()
        }
    }
}


