//
//  OnboardingModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 19/11/2025.
//

import Foundation

struct OnboardingModel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let stepNumber: Int
}
