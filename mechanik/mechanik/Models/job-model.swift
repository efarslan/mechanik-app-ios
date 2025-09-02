//
//  Job.swift
//  mechanik
//
//  Created by efe arslan on 29.08.2025.
//

import Foundation
import FirebaseFirestore

struct Job: Codable, Identifiable {
    @DocumentID var id: String?
    let jobTitle: String
    let mileage: String
    let notes: String
    let selectedSubJobs: [String]
    let brandText: [String: String]
    let quantity: [String: Int]
    let unitPrice: [String: Double]
    let photos: [String]
    let createdAt: Date
    
    // Firestore'a kaydetmek için dictionary
    var dictionary: [String: Any] {
        return [
            "jobTitle": jobTitle,
            "mileage": mileage,
            "notes": notes,
            "selectedSubJobs": selectedSubJobs,
            "brandText": brandText,
            "quantity": quantity,
            "unitPrice": unitPrice,
            "photos": photos,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
