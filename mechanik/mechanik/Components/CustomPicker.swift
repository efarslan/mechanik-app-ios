//
//  CustomBrandPicker.swift
//  mechanik
//
//  Created by efe arslan on 20.08.2025.
//


import SwiftUI

struct CustomBrandPicker: View {
    @Binding var selectedBrand: String
    let brands: [String]
    let placeholder: String
    let logoWidth: CGFloat
    let logoHeight: CGFloat
    
    // Varsayılan değerler ile initializer
    init(
        selectedBrand: Binding<String>,
        brands: [String],
        placeholder: String = String(localized: "Select Brand"),
        logoWidth: CGFloat = 20,
        logoHeight: CGFloat = 20
    ) {
        self._selectedBrand = selectedBrand
        self.brands = brands
        self.placeholder = placeholder
        self.logoWidth = logoWidth
        self.logoHeight = logoHeight
    }
    
    var body: some View {
        Menu {
            ForEach(brands, id: \.self) { brand in
                Button(action: {
                    selectedBrand = brand
                }) {
                    HStack {
                        Image("\(brand.lowercased())_logo")
                            .resizable()
                            .frame(width: logoWidth, height: logoHeight)
                        Text(brand)
                    }
                }
            }
        } label: {
            HStack {
                if !selectedBrand.isEmpty {
                    Image("\(selectedBrand.lowercased())_logo")
                        .resizable()
                        .frame(width: logoWidth, height: logoHeight)
                }
                
                Text(selectedBrand.isEmpty ? placeholder : selectedBrand)
                    .foregroundColor(selectedBrand.isEmpty ? .gray : .primary)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 50) // Sabit minimum yükseklik
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.2), value: selectedBrand.isEmpty) // Smooth geçiş
        }
    }
}

// MARK: Custom Universal Picker

struct CustomPicker: View {
    @Binding var selectedItem: String
        let items: [String]
        let placeholder: String
        
        init(
            selectedItem: Binding<String>,
            items: [String],
            placeholder: String = "Select"
        ) {
            self._selectedItem = selectedItem
            self.items = items
            self.placeholder = placeholder
        }
        
    var body: some View {
        Menu {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    selectedItem = item
                }) {
                    Text(item)
                }
            }
        } label: {
            HStack {
                Text(selectedItem.isEmpty ? placeholder : selectedItem)
                    .foregroundColor(selectedItem.isEmpty ? .gray : .primary)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
        }
    }
}


