//
//  customEditor.swift
//  mechanik
//
//  Created by efe arslan on 26.08.2025.
//

import SwiftUI

struct customEditor: View {
    
    @Binding var text: String
    let placeholder: String
    let characterLimit: Int
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty && !isFocused {
                Text(placeholder)
                    .foregroundColor(.secondary)
                    .padding()
                    .zIndex(1)
            }
            TextEditor(text: $text)
                .focused($isFocused)
                .padding()
                .cornerRadius(30)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray.opacity(0.4), lineWidth: 1))
                
                .onChange(of: text) { newValue in
                    if newValue.count > characterLimit {
                        text = String(newValue.prefix(characterLimit))
                    }
                }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(text.count)/\(characterLimit)")
                        .font(.subheadline)
                        .foregroundColor(text.count > Int(Double(characterLimit) * 0.75) ? .red : .gray)
                        .padding(.horizontal)
                        .padding(.vertical)
                }
            }
        }
    }
}

//#Preview {
//    addNewJob()
//}
