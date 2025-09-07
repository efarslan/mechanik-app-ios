//
//  SearchBar.swift
//  mechanik
//
//  Created by efe arslan on 19.08.2025.
//


import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(10)
                .padding(.horizontal, 30) // solda-search icon için boşluk
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                
        }
    }
}

#Preview {
    MainScreen(isTabBarHidden: .constant(true))
}

#Preview {
    CarsScreen(isTabBarHidden: .constant(true))
}
