//
//  LoginView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 24/11/2025.
//

import SwiftUI
import IQKeyboardManagerSwift
import FirebaseAuth

// MARK: - LoginView
struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var flow: SplashFlowViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
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
                
                // MARK: - ScrollView
                ScrollView {
                    VStack(spacing: 0) {
                        logoSection.padding(.vertical, 50)
                        loginFormSection.frame(minHeight: UIScreen.main.bounds.height)
                    }
                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Logo
    private var logoSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.lightBeige)
                .frame(width: 100, height: 100)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            
            Image(systemName: "chart.bar.xaxis")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.black)
        }
    }
    
    // MARK: - Login Form View
    private var loginFormSection: some View {
        ZStack(alignment: .top) {
            CustomRoundedCorner(radius: 80, corners: [.topLeft])
                .fill(Color.lightBeige)
                .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
            
            VStack(spacing: 25) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                // Email Field
                CustomTextField(
                    title: "Email",
                    text: $viewModel.email,
                    isSecure: false,
                    error: viewModel.emailError,
                    systemImage: "envelope"
                )
                .onChange(of: viewModel.email) {
                    viewModel.validateEmailLive()
                }
                
                // Password Field
                CustomTextField(
                    title: "Password",
                    text: $viewModel.password,
                    isSecure: !viewModel.isPasswordVisible,
                    error: viewModel.passwordError,
                    systemImage: "lock",
                    toggleSecure: {
                        viewModel.isPasswordVisible.toggle()
                    },
                    isSecureToggleVisible: true,
                    isSecureOn: viewModel.isPasswordVisible
                )
                .onChange(of: viewModel.password) {
                    viewModel.validatePasswordLive()
                }
    
                // Login Button
                CustomButton(title: "Login", isEnabled: viewModel.isFormValid && !viewModel.isLoading) {
                    loginAction()
                }
                .padding(.top, 20)
                
                // Sign Up Section
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.black)
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 35)
            .padding(.top, 40)
        }
    }
}

// MARK: -  Actions
extension LoginView {
    private func loginAction() {
        guard viewModel.validate() else { return }
        NotificationManager.shared.performWithLoading { completion in
            viewModel.login { success in
                if success {
                    flow.state = .home
                    completion(nil)
                } else {
                    completion(viewModel.loginError)
                }
            }
        }
    }
}


// MARK: - Preview
#Preview {
    LoginView()
}
