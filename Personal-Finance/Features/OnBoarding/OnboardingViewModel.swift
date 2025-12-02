//
//  OnboardingViewModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 25/11/2025.
//

import Foundation
import Combine


class OnboardingViewModel: ObservableObject {
    
    @Published var currentStep = 0
    @Published var onboardingSteps: [OnboardingModel] = []
    @Published var isOnboardingComplete = false
    
    init() {
        setupOnboardingSteps()
    }
    
    private func setupOnboardingSteps() {
        onboardingSteps = [
            OnboardingModel(
                title: "Track Your Finances",
                description: "Monitor your income and expenses with beautiful charts and insights.",
                imageName: "chart.pie.fill",
                stepNumber: 1
            ),
            OnboardingModel(
                title: "Stay on Budget",
                description: "Set budgets and get notified when you're close to your limits.",
                imageName: "wallet.bifold.fill",
                stepNumber: 2
            ),
            OnboardingModel(
                title: "Secure & Private",
                description: "Your financial data is encrypted and stored securely on your device.",
                imageName: "lock.shield.fill",
                stepNumber: 3
            )
        ]
    }
    
    func nextStep() {
        if currentStep < onboardingSteps.count - 1 {
            currentStep += 1
        } else {
            completeOnboarding()
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
     func completeOnboarding() {
        isOnboardingComplete = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
         
    }
    
    var progress: Double {
        guard !onboardingSteps.isEmpty else { return 0 }
        return Double(currentStep + 1) / Double(onboardingSteps.count)
    }
    
    var isLastStep: Bool {
        currentStep == onboardingSteps.count - 1
    }
}
