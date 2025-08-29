//
//  Job.swift
//  mechanik
//
//  Created by efe arslan on 29.08.2025.
//


import Foundation
import FirebaseFirestore

struct Job: Codable, Identifiable {
    var id: String = UUID().uuidString
    var jobType: String
    var mileage: String
    var notes: String
    var selectedSubJobs: [String]
    var brandText: [String: String]
    var quantityText: [String: String]
    var unitPriceText: [String: String]
    var photos: [String]
    var createdAt: Date = Date()
    
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
