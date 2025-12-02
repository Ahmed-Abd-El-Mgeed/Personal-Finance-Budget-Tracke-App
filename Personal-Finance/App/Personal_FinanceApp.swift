//
//  Personal_FinanceApp.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 19/11/2025.
//

import SwiftUI
import IQKeyboardManagerSwift
import FirebaseCore


@main
struct Personal_FinanceApp: App {
    
    @StateObject var flow = SplashFlowViewModel()
    
    init() {
           IQKeyboardManager.shared.isEnabled = true
           IQKeyboardManager.shared.resignOnTouchOutside = true
        
           // Firebase setup
            FirebaseApp.configure()
       }
      
      var body: some Scene {
          WindowGroup {
              RootView()
                  .environmentObject(flow)
          }
      }
}
