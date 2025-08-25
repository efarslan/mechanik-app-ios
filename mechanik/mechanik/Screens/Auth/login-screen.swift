//
//  login-screen.swift
//  mechanik
//
//  Created by efe arslan on 19.08.2025.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showRegister = false // Register ekranını göstermek için

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                Text("Sign In")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 30)
                
                // Email TextField
                TextField("E-Mail", text: $viewModel.email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                // Password SecureField
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .autocapitalization(.none)
                
                //Register Button
                NavigationLink(destination: RegisterScreen()) {
                    Text("Don't have an account? Sign Up!")
                        .foregroundColor(.blue)
                }
                
                // Login Button
                Button(action: {
                    viewModel.loginUser()
                }) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.customGreen)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .disabled(viewModel.isLoading)
                
                // Loading indicator
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                
                // Error message
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                main_tab_view()
            }
        }
    }
}

#Preview {
    LoginScreen()
        .environment(\.locale, .init(identifier: "tr")) // Türkçe
}

#Preview {
    LoginScreen()
        .environment(\.locale, .init(identifier: "en")) // İngilizce
}
