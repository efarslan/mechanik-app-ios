import SwiftUI

struct RegisterScreen: View {
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            TextField("Ad Soyad", text: $viewModel.adSoyad)
                .padding()
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            
            TextField("İşletme Adı", text: $viewModel.isletmeAdi)
                .padding()
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            
            TextField("Email", text: $viewModel.email)
                .padding()
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Şifre", text: $viewModel.password)
                .padding()
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .autocapitalization(.none)
            
            Button(action: {
                viewModel.registerUser()
            }) {
                Text("Kayıt Ol")
                    .frame(maxWidth: .infinity) // Genişliği Button’a taşı
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

#Preview {
    RegisterScreen()
}
