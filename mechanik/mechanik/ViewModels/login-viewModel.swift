//
//  login-view-model.swift
//  mechanik
//
//  Created by efe arslan on 19.08.2025.
//

import Foundation
import SwiftUI
import FirebaseAuth

class LoginViewModel: ObservableObject {
    // Input alanları
    @Published var email = ""
    @Published var password = ""
    
    // UI state
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isLoggedIn = false // Başarılı giriş sonrası TabView için
    
    func loginUser() {
        // Basit validation
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Lütfen tüm alanları doldurun."
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isLoggedIn = true
                    print("Giriş başarılı: \(result?.user.email ?? "")")
                }
            }
        }
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch let signOutError as NSError {
            self.errorMessage = "Çıkış yapılamadı: \(signOutError.localizedDescription)"
        }
    }
}
