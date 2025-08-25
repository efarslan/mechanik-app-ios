//
//  Button.swift
//  mechanik
//
//  Created by efe arslan on 25.08.2025.
//


import SwiftUI

struct CustomButton: View {
    enum ImagePosition {
        case leading
        case trailing
    }

    let buttonText: String
    let buttonTextColor: Color
    let buttonImage: String
    let buttonColor: Color
    var imagePosition: ImagePosition = .trailing
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if imagePosition == .leading {
                    Image(systemName: buttonImage)
                    Spacer()
                    Text(buttonText)
                } else {
                    Text(buttonText)
                    Spacer()
                    Image(systemName: buttonImage)
                }
            }
            .foregroundColor(buttonTextColor)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(buttonColor)
            .cornerRadius(15)
        }
    }
}
