//
//  main-screen.swift
//  mechanik
//
//  Created by efe arslan on 19.08.2025.
//

import SwiftUI
import FirebaseFirestore

struct MainScreen: View {
    @Binding var isTabBarHidden: Bool
    @State private var searchText: String = ""
    @State private var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    @State private var selectedCar: Car? = nil
    @State private var navigateToCarDetail: Bool = false

    
    //View Models
    @StateObject private var viewModel = UserViewModel()
    @StateObject private var carViewModel = FetchCarsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 36) {
                header
                ScrollView {
                    searchTab
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchCurrentUser()
                carViewModel.fetchCars()
            }
            .navigationDestination(isPresented: $navigateToCarDetail) {
                if let car = selectedCar {
                    CarDetails(car: car)
                        .onAppear { isTabBarHidden = true }
                        .onDisappear { isTabBarHidden = false }
                }
            }
        }
    }
        
    //MARK: - Header
    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Welcome,")
                //TODO: Good M, good evening gibi karşılamalar olabilir.**
                    .font(.custom("Times New Roman", size: UIScreen.main.bounds.width * 0.060))
                    .foregroundColor(.secondary)
                
                Text(viewModel.currentUser?.businessName ?? "User")
                    .font(.system(size: UIScreen.main.bounds.width * 0.060))
            }
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.width * 0.15)
            //TODO: Profile, settings gibi işlevler eklenerek buton haline getirilecek.
        }
    }
    
    //MARK: - Search Tab
    private var searchTab: some View {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThickMaterial)
                .overlay(
                    VStack(alignment: .leading, spacing: 24) {
                        SearchBar(text: $searchText)
                            .onChange(of: searchText) {
                                // boşlukları otomatik sil
                                if searchText.contains(" ") {
                                    searchText = searchText.replacingOccurrences(of: " ", with: "")
                                }
                            }
                            .onSubmit {
                                let newValue = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !newValue.isEmpty {
                                    searchForCar(with: newValue)
                                    
                                    // Eğer eşleşme bulunduysa recentSearches'e ekle
                                    if selectedCar != nil && !recentSearches.contains(newValue) {
                                        recentSearches.insert(newValue, at: 0)
                                        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
                                        if recentSearches.count > 5 {
                                            recentSearches.removeLast()
                                            UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
                                        }
                                    }
                                }
                                searchText = ""
                            }
                        
                        if !recentSearches.isEmpty {
                            
                            HStack {
                                Text("Recent Searches")
                                    .font(.headline )
                                    .foregroundColor(.secondary)
                                    
                                Spacer()
                                
                                Button(action: {
                                        recentSearches.removeAll()
                                        UserDefaults.standard.removeObject(forKey: "recentSearches")
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                        .font(.headline)
                                }
                            }
                            .padding(.top, 4)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 40) {
                                    ForEach(recentSearches.prefix(5), id: \.self) { search in
                                        if let matchedCar = carViewModel.cars.first(where: { $0.license.uppercased() == search.uppercased() }) {
                                            circleLogo(brand: matchedCar.brand, plateNumber: matchedCar.license, useBrandLogo: true)
                                                .onTapGesture {
                                                    searchText = search
                                                    searchForCar(with: search)
                                                }
                                        } else {
                                            circleLogo(brand: nil, plateNumber: search.uppercased(), useBrandLogo: false)
                                                .onTapGesture {
                                                    searchText = search
                                                    searchForCar(with: search)
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding()
                )
                .frame(height: recentSearches.isEmpty ? UIScreen.main.bounds.height * 0.09 : UIScreen.main.bounds.height * 0.3)
                .animation(.easeInOut(duration: 0.5), value: recentSearches.isEmpty)
                .fixedSize(horizontal: false, vertical: true)
            
    }
    
    //MARK: - In Progress jobs
    
    // MARK: - Search functionality
    private func searchForCar(with plateNumber: String) {
        let trimmedPlate = plateNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let foundCar = carViewModel.cars.first(where: { car in
            car.license.lowercased() == trimmedPlate.lowercased()
        }) {
            selectedCar = foundCar
            navigateToCarDetail = true
        } else {
            print("Araç bulunamadı: \(trimmedPlate)")
        }
    }

}

#Preview {
    MainScreen(isTabBarHidden: .constant(false))
}
