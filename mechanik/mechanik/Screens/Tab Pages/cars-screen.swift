//
//  cars-screen.swift
//  mechanik
//
//  Created by efe arslan on 19.08.2025.
//

import SwiftUI

struct CarsScreen: View {
    @State private var searchText: String = ""
    
    @StateObject private var viewModel = FetchCarsViewModel()
    var body: some View {
        
        NavigationStack {
            ZStack {
                VStack {
                    VStack {
                        SearchBar(text: $searchText)
                            .padding()
                        
                    }
                    ScrollView{
                        LazyVStack(spacing: 30) {
                            ForEach(viewModel.cars) {car in
                                VehicleCard(brand: car.brand, model: car.model, plateNumber: car.license, engineSize: car.engineSize, fuelType: car.fuelType)}
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: AracEklemeScreen()) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                                .frame(width: 56, height: 56)
                                .background(Circle().fill(Color.color1))
                                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchCars()
        }
    }
}

#Preview {
    CarsScreen()
}
