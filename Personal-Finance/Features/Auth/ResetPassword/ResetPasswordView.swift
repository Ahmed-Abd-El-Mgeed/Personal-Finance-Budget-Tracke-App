//
//  ResetPasswordView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 27/11/2025.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @StateObject private var viewModel = ResetPasswordViewModel()
    @EnvironmentObject var flow: SplashFlowViewModel
    
    var body: some View {
        
        ZStack{
            // screen Background
            Color.black.ignoresSafeArea()
            
            // Animated Dollars
            GeometryReader { geo in
                ForEach(viewModel.dollars) { item in
                    Text("$")
                        .font(.system(size: item.size))
                        .foregroundColor(.lightBeige.opacity(item.opacity))
                        .position(
                            x: item.x * geo.size.width,
                            y: item.y * geo.size.height
                        )
                }
            }
            .allowsHitTesting(false)
        }
    }
}

#Preview {
    ResetPasswordView()
}
