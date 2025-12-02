//
//  OnboardingView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 19/11/2025.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject var viewModel = OnboardingViewModel()
    @EnvironmentObject var flow: SplashFlowViewModel
    
    var body: some View {
        ZStack {
            // MARK: - Background Color
            Color.lightBeige
                .ignoresSafeArea()
            
            VStack {
                
                // MARK: - Skip Button
                skipButton
                
                // MARK: - Pages TabView
                pagesTabView
                
                // MARK: - Page Indicators
                pageIndicators
                
                // MARK: - Next / Get Started Button
                nextButton
            }
        }
    }
    
    // MARK: - Skip Button
    private var skipButton: some View {
        HStack {
            Spacer()
            Button("Skip") {
                flow.completeOnboarding()
            }
            .foregroundColor(.black)
            .bold()
            .padding(.trailing, 20)
            .padding(.top, 10)
        }
    }
    
    // MARK: - Pages TabView
    private var pagesTabView: some View {
        TabView(selection: $viewModel.currentStep) {
            ForEach(viewModel.onboardingSteps.indices, id: \.self) { index in
                OnboardingPage(step: viewModel.onboardingSteps[index])
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    // MARK: - Page Indicators
    private var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.onboardingSteps.indices, id: \.self) { index in
                Capsule()
                    .fill(index == viewModel.currentStep ? .black : .gray.opacity(0.3))
                    .frame(width: index == viewModel.currentStep ? 20 : 8, height: 8)
                    .animation(.easeInOut, value: viewModel.currentStep)
            }
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Next / Get Started Button
    private var nextButton: some View {
        Button {
            if viewModel.isLastStep {
                flow.completeOnboarding()
            } else {
                viewModel.currentStep += 1
            }
        } label: {
            HStack {
                Text(viewModel.isLastStep ? "Get Started" : "Next")
                Image(systemName: "chevron.right")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 14)
            .background(Color.black)
            .clipShape(Capsule())
            .shadow(radius: 4)
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    OnboardingView()
}
