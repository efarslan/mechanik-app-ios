//
//  subJobBox.swift
//  mechanik
//
//  Created by efe arslan on 26.08.2025.
//

import SwiftUI

struct SubJobBox: View {
    let jobName: String
    @Binding var brand: String
    @Binding var quantityText: String
    @Binding var unitPriceText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey(jobName))
                .foregroundColor(.white)
                .font(.headline)
                .bold()
            
            ZStack(alignment: .leading) {
                if brand.isEmpty {
                    Text("Brand")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                        .zIndex(1)
                }
                
                customTextField(placeholder: "", text: $brand, showError: .constant(nil))
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(30)
            }
            
            ZStack(alignment: .leading) {
                if quantityText.isEmpty {
                    Text("Quantity")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                        .zIndex(1)
                }
                
                customTextField(placeholder: "", text: $quantityText,showError: .constant(nil))
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(30)
                    .keyboardType(.numberPad)

            }
                

            ZStack(alignment: .leading) {
                if unitPriceText.isEmpty {
                    Text("Unit Price")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                        .zIndex(1)
                }
                
                customTextField(placeholder: "", text: $unitPriceText, showError: .constant(nil))
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(30)
                    .keyboardType(.decimalPad)

            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.color1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color(.gray), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

//#Preview {
//    addNewJob()
//}


