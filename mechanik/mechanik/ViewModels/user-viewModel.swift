//
//  user-view-model.swift
//  mechanik
//
//  Created by efe arslan on 4.09.2025.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var currentUser: UserModel?

    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            if let data = snapshot?.data() {
                self.currentUser = UserModel(
                    id: uid,
                    name: data["name"] as? String ?? "",
                    businessName: data["businessName"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    phone: data["phone"] as? String ?? "",
                    userStatus: data["userStatus"] as? Int ?? 0
                )
            }
        }
    }
}
