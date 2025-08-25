//
//  addNewCar-view-model.swift
//  mechanik
//
//  Created by efe arslan on 20.08.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AddCarViewModel: ObservableObject {
    @Published var license = ""
    @Published var brand = ""
    @Published var model = ""
    @Published var fuelType = ""
    @Published var engineSize = ""
    @Published var chasisNo = ""
    @Published var carOwner = ""
    @Published var ownerPhoneNumber = ""
    @Published var notes = ""
    
    @Published var brands: [Brand] = []
    @Published var models: [CarModel] = []
    
    private let db = Firestore.firestore()
    
    func fetchBrands() {
        db.collection("brands").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching brands: \(error)")
                return
            }
            
            
            if let documents = snapshot?.documents {
                self.brands = documents.map { doc in
                    let name = doc.documentID
                    return Brand(id: doc.documentID, name: name, logoName: "\(name.lowercased())_logo")
                }
            }
        }
    }
    
    func fetchModels(for brandId: String) {
        db.collection("brands").document(brandId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching models: \(error)")
                return
            }
            
            if let data = snapshot?.data() {
                if let modeller = data["modeller"] as? [Any] {
                    var fetchedModels = modeller.compactMap { element -> CarModel? in
                        guard let dict = element as? [String: Any],
                              let id = dict["id"] as? String else { return nil }
                        return CarModel(id: id, name: id)
                    }
                    if let index = fetchedModels.firstIndex(where: { $0.name == "Diğer" }) {
                        let digerModel = fetchedModels.remove(at: index)
                        fetchedModels.append(digerModel)
                    }
                    self.models = fetchedModels
                    print("Fetched \(self.models.count) models for brand \(brandId)")
                } else {
                    print("No modeller field for brand \(brandId)")
                    self.models = []
                }
            }
        }
    }
    
    func saveCar(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            completion(false)
            return
        }
        
        let carData: [String: Any] = [
            "license": license,
            "brand": brand,
            "model": model,
            "fuelType": fuelType,
            "engineSize": engineSize,
            "chasisNo": chasisNo,
            "carOwner": carOwner,
            "ownerPhoneNumber": ownerPhoneNumber,
            "notes": notes,
            "createdAt": Date()
        ]
        
        db.collection("users")
            .document(userId)
            .collection("cars")
            .document(license)
            .setData(carData) { error in
                if let error = error {
                    print("Error saving car: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
    }
}
