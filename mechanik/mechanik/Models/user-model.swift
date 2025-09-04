//
//  user-model.swift
//  mechanik
//
//  Created by efe arslan on 4.09.2025.
//

import Foundation

struct UserModel: Identifiable, Codable {
    var id: String
    var name: String
    var businessName: String
    var email: String
    var phone: String
    var userStatus: Int
}
