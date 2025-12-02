//
//  SplashView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 19/11/2025.
//

import SwiftUI

struct SplashView: View {
    
    @StateObject private var viewModel = SplashViewModel()
    @EnvironmentObject var flow: SplashFlowViewModel
    
    var body: some View {
        ZStack {
            if viewModel.isActive {
                // MARK: - Onboarding Screen
                OnboardingView()
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.isActive)
            } else {
                // MARK: - Splash Content
                splashContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.lightBeige)
                    .onAppear {
                        viewModel.startAnimation()
                    }
                    .onChange(of: viewModel.isActive) { active in
                        if active {
                            flow.state = .onboarding
                        }
                    }
            }
        }
    }
    
    // MARK: - Splash Content View
    private var splashContent: some View {
        VStack(spacing: 20) {
            animatedChart
            animatedTitle
        }
    }
    
    // MARK: - Animated Chart Image
    private var animatedChart: some View {
        Image(systemName: "chart.bar.xaxis")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .mask(
                Rectangle()
                    .frame(height: 200 * viewModel.fillAmount)
                    .offset(y: 200 * (1 - viewModel.fillAmount) / 2)
            )
            .animation(.easeOut(duration: 3), value: viewModel.fillAmount)
    }
    
    // MARK: - Animated Title Text
    private var animatedTitle: some View {
        HStack(spacing: 0) {
            ForEach(Array(viewModel.title.enumerated()), id: \.offset) { index, letter in
                Text(String(letter))
                    .font(.largeTitle)
                    .bold()
                    .offset(y: viewModel.fillAmount == 1 ? 0 : -200)
                    .opacity(viewModel.fillAmount == 1 ? 1 : 0)
                    .animation(
                        .interpolatingSpring(stiffness: 150, damping: 7)
                            .delay(Double(index) * 0.05),
                        value: viewModel.fillAmount
                    )
            }
        }
    }
}

#Preview {
    SplashView()
}
