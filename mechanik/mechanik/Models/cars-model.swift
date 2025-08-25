//
//  cars.swift
//  mechanik
//
//  Created by efe arslan on 20.08.2025.
//

import Foundation

struct Car: Identifiable, Codable {
    var id: String = UUID().uuidString
    var license: String
    var brand: String
    var model: String
    var fuelType: String
    var engineSize: String
    var chasisNo: String
    var carOwner: String
    var ownerPhoneNumber: String
    var notes: String
    var createdAt: Date = Date()
}

struct Brand: Identifiable {
    var id: String
    var name: String
    var logoName: String
}

struct CarModel: Identifiable {
    var id: String
    var name: String
}
