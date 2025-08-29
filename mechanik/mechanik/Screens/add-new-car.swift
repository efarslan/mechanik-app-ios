//
//  add-new-car.swift
//  mechanik
//
//  Created by efe arslan on 20.08.2025.
//

// TODO: Diğer plaka formatları eklenecek.


import SwiftUI

struct AracEklemeScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentState = 1
    // Aşama 1
    @State private var license = ""
    @State private var showLicenseError: Bool? = nil
    
    // Aşama 2
    @State private var brand = ""
    @State private var model = ""
    @State private var year = ""
    @State private var fuelType = ""
    @State private var engineSize = ""
    @State private var chasisNo = ""
    @State private var selectedModelKey = ""
    @State private var showYearError: Bool? = nil
    
    // Aşama 3
    @State private var carOwner = ""
    @State private var ownerPhoneNumber = ""
    @State private var notes = ""
    @State private var showOwnerError: Bool? = nil

    @StateObject var viewModel = AddCarViewModel()
    
    let fuelsList = ["Petrol", "Diesel", "LPG", "Hybrid", "Electric"]

    var body: some View {
        VStack(spacing: 20) {
            
            HStack(spacing: 20) {
                ForEach(1...3, id: \.self) { step in
                    Circle()
                        .fill(step <= currentState ? Color.color1 : Color.gray.opacity(0.3))
                        .frame(width: 15, height: 15)
                }
            }
            .padding(.vertical)
            
            ScrollView {
                VStack (alignment: .leading) {
                    if currentState == 1 {
                        licensePlateView
                    } else if currentState == 2 {
                        vehicleInfoView
                    } else if currentState == 3 {
                        ownerInfoView
                    }
                }
                .padding()
                .scrollIndicators(.hidden)
                .background(Color(.systemBackground))
                .navigationBarTitleDisplayMode(.inline)
                
            }
            
            HStack {
                CustomButton(buttonText: currentState > 1 ? "Back" : "Cancel", buttonTextColor: .white, buttonImage: currentState > 1 ? "chevron.left" : "xmark", buttonColor: currentState > 1 ? .color2 : Color.red, imagePosition: .leading) {
                    withAnimation(.easeInOut) {
                        if currentState > 1 {
                            currentState -= 1
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                
                CustomButton(buttonText: currentState >= 3 ? "Save" : "Next", buttonTextColor: .color2, buttonImage: "chevron.right", buttonColor: .color1) {
                    if currentState == 1 {
                        if license.isEmpty || license.count < 7 {
                            showLicenseError = true
                            return
                        } else {
                            showLicenseError = false
                            currentState += 1
                        }
                    }
                    
                    else if currentState == 2 {
                        if year.isEmpty || Int(year) == nil || year.count != 4 {
                            showYearError = true
                            return
                        } else {
                            showYearError = false
                            currentState += 1
                        }
                    }
                    
                    else if currentState == 3 {
                        if carOwner.isEmpty {
                            showOwnerError = true
                            return
                        } else {
                            showOwnerError = false
                        }
                        withAnimation(.easeInOut) {
                            viewModel.license = license
                            viewModel.brand = brand
                            viewModel.model = model
                            if let yearInt = Int(year) {
                                viewModel.year = yearInt
                            } else {
                                viewModel.year = Calendar.current.component(.year, from: Date())
                            }
                            viewModel.fuelType = fuelType

                            if fuelType != "Electric" {
                                viewModel.engineSize = engineSize
                            } else { engineSize = "-" }

                            viewModel.chasisNo = chasisNo
                            viewModel.carOwner = carOwner
                            viewModel.ownerPhoneNumber = ownerPhoneNumber
                            viewModel.notes = notes

                            viewModel.saveCar { success in
                                if success {
                                    print("✅ Car saved successfully")
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    print("❌ Failed to save car")
                                }
                            }
                        }
                    }
                }

                    
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding()
        .onAppear {
            viewModel.fetchBrands()
        }

    }
    //MARK: - License Plate Section
    private var licensePlateView: some View {
        VStack(spacing: 25) {
            Image("new-car")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 400, maxHeight: 400)
                .padding(.horizontal)
                
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 5)
                        .fill(Color.blue)
                        .frame(width: 40, height: 70)
                
                TextField("34 ABC 123", text: $license)
                    .padding(.horizontal)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
                    .background(Color.white)
                    .autocapitalization(.allCharacters)
                    .keyboardType(.asciiCapable)
                    .multilineTextAlignment(.center)
                    .onChange(of: license) { oldValue, newValue in
                        let filtered = newValue.filter { $0.isLetter || $0.isNumber }
                        if filtered.count > 10 {
                            license = String(filtered.prefix(10))
                        } else {
                            license = filtered
                        }
                    }

            }
            .background(Color.white)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        (showLicenseError == true || (license.count > 0 && license.count < 7)) ? Color.red : Color.primary,
                        lineWidth: 3
                    )
            )

        
        }
    }
    //MARK: - Vehicle Info Section
    private var vehicleInfoView: some View {
        VStack(spacing: 15) {
            Text("Vehicle Information")
                .font(.title2)
                .bold()
            //Brand Picker
            CustomBrandPicker(
                selectedBrand: $brand, brands: viewModel.brands.map { $0.name }
            )
            
            //Model Picker
            CustomPicker(
                selectedItem: $model,
                items: viewModel.models.map { $0.name },
                placeholder: String(localized: "Select Model")
            )
            .disabled(brand.isEmpty)
            .background(brand.isEmpty ? Color.gray.opacity(0.2) : Color(UIColor.systemBackground))
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .onChange(of: brand) { oldValue, newBrand in
                model = ""
                viewModel.fetchModels(for: newBrand)
            }
            
            customTextField(placeholder: "Year", text: $year, isRequired: true, showError: $showYearError)
            
            
            //Fuel Picker
            CustomPicker(selectedItem: $fuelType, items: fuelsList, placeholder: String(localized: "Select Fuel Type"))
            
            // İçten Yanmalı Motor ise
            //TODO: Şanzıman türü eklenecek (otomatik-manuel)
            //TODO: Araç model yılı eklenecek.
            
            if !fuelType.isEmpty && fuelType != "Electric" {
                    TextField("Engine Size (cc)", text: $engineSize)
                        .padding()
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .keyboardType(.numberPad)
                
            }
            customTextField(placeholder: "Chasis Number (Optional)", text: $chasisNo,showError: .constant(nil))

            
        }
    }
    //MARK: - Owner Info Section
    private var ownerInfoView: some View {
        VStack(spacing: 15) {
            Text("Vehicle Owner Information")
                .font(.title2)
                .bold()
            
            customTextField(placeholder: "Owners Name", text: $carOwner,isRequired: true, showError: $showOwnerError)

            customTextField(placeholder: "Owners Phone Number", text: $ownerPhoneNumber, showError: .constant(nil))
                .keyboardType(.phonePad)
            
            customEditor(text: $notes, placeholder: String (localized:"Notes"), characterLimit: 150)
                .frame(minHeight: 150)
            
                    //TODO: Kullanıcıya başarılı bilgisini gösteren bir uyarı.
                
            }
    }
    
}
//MARK: - Previews
#Preview {
    AracEklemeScreen()
        .environment(\.locale, .init(identifier: "tr"))
}

#Preview {
    AracEklemeScreen()
        .environment(\.locale, .init(identifier: "eng"))
}
