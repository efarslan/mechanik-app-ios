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
    let jobType: String
    let mileage: String
    let notes: String
    let selectedSubJobs: [String]
    let brandText: [String: String]
    let quantityText: [String: String]
    let unitPriceText: [String: String]
    let photos: [String]
    let createdAt: Date
    
    // Firestore'a kaydetmek için dictionary
    var dictionary: [String: Any] {
        return [
            "jobType": jobType,
            "mileage": mileage,
            "notes": notes,
            "selectedSubJobs": selectedSubJobs,
            "brandText": brandText,
            "quantityText": quantityText,
            "unitPriceText": unitPriceText,
            "photos": photos,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
