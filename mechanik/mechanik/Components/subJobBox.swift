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
            
            TextField("Brand", text: $brand)
                .padding(8)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(30)
            
            TextField("Quantity", text: $quantityText)
                .padding(8)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(30)
                .keyboardType(.numberPad)
                .onChange(of: quantityText) { newValue in
                    quantityText = newValue.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                }

            TextField("Unit Price", text: $unitPriceText)
                .padding(8)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(30)
                .keyboardType(.decimalPad)
                .onChange(of: unitPriceText) { newValue in
                    // Rakam, nokta ve virgül dışında karakterleri temizle
                    var filtered = newValue.replacingOccurrences(of: "[^0-9.,]", with: "", options: .regularExpression)
                    // Virgül varsa noktaya çevir
                    filtered = filtered.replacingOccurrences(of: ",", with: ".")
                    unitPriceText = filtered
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
