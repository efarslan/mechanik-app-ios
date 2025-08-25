//
//  fetch-cars-view-model.swift
//  mechanik
//
//  Created by efe arslan on 25.08.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FetchCarsViewModel: ObservableObject {
    @Published var cars: [Car] = []
    
    private let db = Firestore.firestore()
    
    func fetchCars() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No logged in user")
            return
        }
        
        db.collection("users")
            .document(userId)
            .collection("cars")
            .getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let fetchedCars = documents.compactMap { doc -> Car? in
                    try? doc.data(as: Car.self)
                }
                
                DispatchQueue.main.async {
                    self?.cars = fetchedCars
                }
            }
    }
}
