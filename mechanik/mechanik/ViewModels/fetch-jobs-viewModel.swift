//
//  JobsViewModel.swift
//  mechanik
//
//  Created by efe arslan on 29.08.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class JobsViewModel: ObservableObject {
    @Published var jobs: [Job] = []
    
    func fetchJobs(for carId: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("cars")
            .document(carId)
            .collection("jobs")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching jobs: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    return
                }
                
                self.jobs = documents.compactMap { doc in
                    try? doc.data(as: Job.self)
                }
            }
    }
}
