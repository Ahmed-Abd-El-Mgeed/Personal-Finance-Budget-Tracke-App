//
//  SignUpView.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 27/11/2025.
//

import SwiftUI

struct SignUpView: View {

    @StateObject private var viewModel = SignUpViewModel()
    @EnvironmentObject var flow: SplashFlowViewModel
    @Environment(\.dismiss) private var dismiss


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
            
            // MARK: - ScrollView
            ScrollView{
                VStack(spacing: 0) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.lightBeige)
                }
                .padding()
                signUpFormSection.frame(minHeight: UIScreen.main.bounds.height)
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .bottom)
        }
        
    }
    
    // MARK: - SignUp Form View
    private var signUpFormSection: some View {
        ZStack(alignment: .top) {
            CustomRoundedCorner(radius: 80, corners: [.topLeft])
                .fill(Color.lightBeige)
                .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
            
            VStack(spacing: 25) {
                
                // user name Field
                CustomTextField(
                    title: "User Name",
                    text: $viewModel.userName,
                    isSecure: false,
                    error: viewModel.userNameError,
                    systemImage: "person"
                )
                .onChange(of: viewModel.userName) {
                    viewModel.validateUserNameLive()
                }
                
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
                
                // Confrim Password Field
                CustomTextField(
                    title: "Confrim Password",
                    text: $viewModel.confirmPassword,
                    isSecure: !viewModel.isConfirmPasswordVisible,
                    error: viewModel.confirmError,
                    systemImage: "lock",
                    toggleSecure: {
                        viewModel.isConfirmPasswordVisible.toggle()
                    },
                    isSecureToggleVisible: true,
                    isSecureOn: viewModel.isPasswordVisible
                )
                .onChange(of: viewModel.confirmPassword) {
                    viewModel.validateConfirmPasswordLive()
                }
                
                // signUp Button
                CustomButton(title: "Sign Up", isEnabled: viewModel.isFormValid && !viewModel.isLoading) {
                    signUp()
                }
                .padding(.top, 20)
                
                // Sign In Section
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.black)
                    
                    Button("Login") {
                        dismiss()
                    }
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                }
                .padding(.bottom, 30)
                
            }
            .padding(.horizontal, 35)
            .padding(.top, 40)
        }
    }
}

// MARK: - Actions
extension SignUpView {
    private func signUp(){
        guard viewModel.validate() else { return }
        NotificationManager.shared.performWithLoading { completion in
            viewModel.signUp { success in
                if success {
                    flow.state = .home
                    completion(nil)
                } else {
                    completion(viewModel.signUpError)
                }
            }
        }
        
    }
}



#Preview {
    SignUpView()
}

