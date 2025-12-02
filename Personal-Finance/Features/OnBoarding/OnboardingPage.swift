//
//  OnboardingPage.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 19/11/2025.
//

import SwiftUI

struct OnboardingPage: View {
    let step: OnboardingModel
    @State private var appear = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // MARK: - Image Section
            imageSection
            
            // MARK: - Text Section
            textSection
            
            Spacer()
        }
        .onAppear { appear = true }
        .onDisappear { appear = false }
    }
    
    // MARK: - Image Section
    private var imageSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.black)
                .frame(width: 160, height: 160)
                .shadow(radius: 20)
            
            Image(systemName: step.imageName)
                .foregroundColor(.white)
                .font(.system(size: 60))
                .scaleEffect(appear ? 1 : 0.5)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.5),
                    value: appear
                )
        }
    }
    
    // MARK: - Text Section
    private var textSection: some View {
        VStack(spacing: 12) {
            // Title
            Text(step.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
                .opacity(appear ? 1 : 0)
                .animation(.easeIn(duration: 0.6), value: appear)
            
            // Description
            Text(step.description)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(appear ? 1 : 0)
                .animation(.easeIn(duration: 0.6).delay(0.2), value: appear)
        }
    }
}

