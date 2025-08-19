//
//  hex+color.swift
//  mechanik
//
//  Created by efe arslan on 19.08.2025.
//


import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // opsiyonel #

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

extension Color {
    static let background = Color(hex: "#f8f8f8")
    static let primaryColor = Color(hex: "#F5DF40")
    static let secondaryColor = Color(hex: "#433232")
    static let customGreen = Color(hex: "#617b65")
}
