//
//  File.swift
//  mechanik
//
//  Created by efe arslan on 28.08.2025.
//

import SwiftUI

struct customTextField : View {
    let placeholder: LocalizedStringKey
    @Binding var text: String
    var isRequired: Bool = false
    @Binding var showError: Bool?
    var characterLimit: Int? = nil
    
    var body: some View {
        TextField(placeholder, text: $text)
            .onChange(of: text) {
                if let limit = characterLimit, text.count > limit {
                    text = String(text.prefix(limit))
                }
            }
            .padding()
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(
                        (showError ?? false) ? Color.red : Color.gray.opacity(0.4),
//                        (showError ?? false) && text.trimmingCharacters(in: .whitespaces).isEmpty && isRequired
//                                ? Color.red
//                                : Color.gray.opacity(0.4),
                            lineWidth: 1
                        )
                )
        }
    }
