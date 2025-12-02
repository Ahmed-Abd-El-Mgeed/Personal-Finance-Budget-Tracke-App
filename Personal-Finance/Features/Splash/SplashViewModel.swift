//
//  SplashViewModel.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 19/11/2025.
//

import Foundation
import SwiftUI
import Combine

class SplashViewModel: ObservableObject{
    
    
    @Published var fillAmount: CGFloat = 0.0
    @Published var isActive: Bool = false
    
    let title = "Finance App"
    
  
     func startAnimation(){
        fillAmount = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5){
            self.isActive = true
            
        }
    }
    
    
}
