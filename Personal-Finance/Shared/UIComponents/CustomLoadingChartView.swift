//
//  CustomLoadingChartView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 26/11/2025.
//

import Foundation
import SwiftUI

// MARK: - Letter-by-letter animated text
struct AnimatedTextView: View {
    let text: String
    @State private var revealedCount: Int = 0
    var duration: Double = 0.12 // speed per letter

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, letter in
                Text(String(letter))
                    .foregroundColor(.white)
                    .font(.headline)
                    .offset(y: revealedCount > index ? 0 : 15) // rise from below
                    .opacity(revealedCount > index ? 1 : 0)
                    .animation(.easeOut(duration: 0.25), value: revealedCount)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { _ in
                revealedCount += 1
                if revealedCount > text.count {
                    revealedCount = 0
                }
            }
        }
    }
}

// MARK: - LoadingChartView Component
struct LoadingChartView: View {
    @State private var fillAmount: CGFloat = 0
    var size: CGFloat = 100
    var boxSize: CGFloat = 75
    var duration: Double = 3.5
    var iconName: String = "chart.bar.xaxis"
    
    var body: some View {
        ZStack {
            // Beige background square
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.lightBeige)
                .frame(width: boxSize, height: boxSize)
                .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
            
            // Chart icon with animated mask
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundColor(.black)
                .mask(
                    Rectangle()
                        .frame(height: size * fillAmount)
                        .offset(y: size * (1 - fillAmount) / 2)
                )
        }
        .onAppear {
            // Endless fill animation with reverse
            withAnimation(.easeOut(duration: duration).repeatForever(autoreverses: true)) {
                fillAmount = 1.0
            }
        }
    }
}

// MARK: - Loading Overlay Modifier
struct LoadingOverlay: ViewModifier {
    let isLoading: Bool
    var size: CGFloat = 100
    var boxSize: CGFloat = 150
    var duration: Double = 3.5
    var iconName: String = "chart.bar.xaxis"
    var backgroundColor: Color = Color.black.opacity(0.7)
    var loadingText: String = "Loading..."
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                // Dimmed background
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    
                    // Animated chart
                    LoadingChartView(
                        size: size,
                        boxSize: boxSize,
                        duration: duration,
                        iconName: iconName
                    )
                    
                    // Animated text (letter-by-letter)
                    AnimatedTextView(text: loadingText)
                }
            }
        }
    }
}

// MARK: - View Extension
extension View {
    func loadingOverlay(
        isLoading: Bool,
        size: CGFloat = 100,
        boxSize: CGFloat = 150,
        duration: Double = 3.5,
        iconName: String = "chart.bar.xaxis",
        backgroundColor: Color = Color.black.opacity(0.7),
        loadingText: String = "Loading..."
    ) -> some View {
        modifier(LoadingOverlay(
            isLoading: isLoading,
            size: size,
            boxSize: boxSize,
            duration: duration,
            iconName: iconName,
            backgroundColor: backgroundColor,
            loadingText: loadingText
        ))
    }
}
