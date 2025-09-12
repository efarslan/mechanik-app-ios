//
//  register-view-model.swift
//  mechanik
//
//  Created by efe arslan on 19.08.2025.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class RegisterViewModel: ObservableObject {
    // Inputs
    @Published var name = ""
    @Published var businessName = ""
    @Published var email = ""
    @Published var password = ""
    
    // UI state
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isRegistered = false
    
    private let db = Firestore.firestore()
    
    func registerUser() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Lütfen tüm alanları doldurun."
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let userId = result?.user.uid else {
                    self?.errorMessage = "Kullanıcı ID alınamadı."
                    return
                }
                
                // Firestore’da kullanıcı dokümanı oluştur
                self?.db.collection("users").document(userId).setData([
                    "name": self?.name ?? "",
                    "businessName": self?.businessName ?? "",
                    "email": self?.email ?? "",
                    "userStatus": 1,
                    "phoneNum": "",
                    "adress": ""
                ]) { error in
                    if let error = error {
                        self?.errorMessage = "Firestore kaydı başarısız: \(error.localizedDescription)"
                    } else {
                        self?.isRegistered = true
                    }
                }
            }
        }
    }
}
