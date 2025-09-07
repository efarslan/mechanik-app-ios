import SwiftUI

struct RegisterScreen: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                        Text("Back")
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 15) {
                    TextField("Name Surname", text: $viewModel.name)
                        .padding()
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    TextField("Business Name", text: $viewModel.businessName)
                        .padding()
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    TextField("E-Mail", text: $viewModel.email)
                        .padding()
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .autocapitalization(.none)
                    
                    Button(action: {
                        viewModel.registerUser()
                    }) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.customGreen)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .disabled(viewModel.isLoading)
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RegisterScreen()
}
