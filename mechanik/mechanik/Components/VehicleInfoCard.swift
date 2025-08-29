//
//  VehicleInfoCard.swift
//  mechanik
//
//  Created by efe arslan on 25.08.2025.
//

import SwiftUI

struct VehicleCard: View {
    let brand: String
    let model: String
    let plateNumber: String
    let engineSize: String
    let fuelType: String
    
    var body: some View {
        HStack(spacing: 0) {
            // Sol taraf: Logo + gri arka plan
            ZStack {
                Color.clear
                    .background(.ultraThinMaterial)
                
                Image("\(brand.lowercased())_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(20)
            }
            .frame(maxWidth: 0.25 * UIScreen.main.bounds.width)
            
            HStack {
            VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(plateNumber)
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        
                    }
                    
                    VStack (alignment: .leading) {
                        Text("\(brand) \(model)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("\(engineSize) \(fuelType) Engine")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .frame(height: 32)
                    .padding(.horizontal)
                // TODO: Buton haline getirilecek.

            }
            .padding()
            .background(Color(.systemBackground))
            
        }
        .frame(height: UIScreen.main.bounds.height * 0.12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    VehicleCard(brand: "Ford", model: "Focus", plateNumber: "34FCS34", engineSize: "1.0", fuelType: "Petrol")
}

#Preview {
    CarsScreen(isTabBarHidden: .constant(false))
}
