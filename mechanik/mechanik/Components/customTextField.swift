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
                .onChange(of: text) { oldValue, newValue in
                    if let limit = characterLimit, newValue.count > limit {
                        text = String(newValue.prefix(limit))
                    }
                }
                .padding()
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            (showError ?? false) && text.trimmingCharacters(in: .whitespaces).isEmpty && isRequired
                                ? Color.red
                                : Color.gray.opacity(0.4),
                            lineWidth: 1
                        )
                )
        }
    }
