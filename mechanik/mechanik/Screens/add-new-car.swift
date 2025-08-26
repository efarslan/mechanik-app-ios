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
    
    // Aşama 2
    @State private var brand = ""
    @State private var model = ""
    @State private var fuelType = ""
    @State private var engineSize = ""
    @State private var chasisNo = ""
    
    // Aşama 3
    @State private var carOwner = ""
    @State private var ownerPhoneNumber = ""
    @State private var notes = ""
    
    @StateObject var viewModel = AddCarViewModel()
    
    let fuelsList = ["Electric", "Hybrid", "LPG", "Diesel", "Petrol"]

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
            
            switch currentState {
            case 1:
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
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.primary, lineWidth: 3))
                    .padding(.horizontal)
                

                }
                Spacer()
                //Cancel-Next Button
                HStack {
                    CustomButton(
                        buttonText: String(localized: "Cancel"), buttonTextColor: .white, buttonImage: "xmark", buttonColor: Color.color2, imagePosition: .leading
                    ) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    
                    CustomButton(
                        buttonText: String(localized: "Next"), buttonTextColor: .color2, buttonImage: "chevron.right", buttonColor: Color.color1
                    ) {
                        withAnimation(.easeInOut) {
                            currentState += 1
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
                
            case 2:
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
                    
                    //Fuel Picker
                    CustomPicker(selectedItem: $fuelType, items: fuelsList, placeholder: String(localized: "Select Fuel Type"))

                    
                    // İçten Yanmalı Motor ise
                    //TODO: Şanzıman türü eklenecek (otomatik-manuel)
                    //TODO: Araç model yılı eklenecek.
                    
                    if fuelType == "Petrol" || fuelType == "Diesel" || fuelType == "Hybrid" {
                        TextField("Engine Size (cc)", text: $engineSize)
                            .padding()
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )                            .keyboardType(.numberPad)
                    }
                    
                    TextField("Chasis Number (Optional)", text: $chasisNo)
                        .padding()
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                }
                Spacer()
                
                //Back-Next Button
                HStack {
                    CustomButton(buttonText: String(localized: "Back"), buttonTextColor: .white, buttonImage: "chevron.left", buttonColor: Color.color2, imagePosition: .leading)
                    {
                        withAnimation(.easeInOut) {
                            currentState -= 1
                        }
                    }
                    
                    CustomButton(buttonText: String(localized: "Next"), buttonTextColor: .color2, buttonImage: "chevron.right", buttonColor: Color.color1)
                    {
                        withAnimation(.easeInOut) {
                            currentState += 1
                        }
                    }
                }
                .padding(.vertical)
                .padding(.horizontal)
                
            case 3:
                VStack(spacing: 15) {
                    Text("Vehicle Owner Information")
                        .font(.title2)
                        .bold()
                    
                    TextField("Owners Name", text: $carOwner)
                        .padding()
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    TextField("Owners Phone Number", text: $ownerPhoneNumber)
                        .padding()
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .keyboardType(.phonePad)
                    
                    TextField("Notes", text:
                    $notes)
                    .padding()
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                            
                            //TODO: Kullanıcıya başarılı bilgisini gösteren bir uyarı.
                        
                    }
                Spacer()
                
                //Back-Save Button
                HStack {
                    CustomButton(buttonText: String(localized: "Back"), buttonTextColor: .white, buttonImage: "chevron.left", buttonColor: Color.color2, imagePosition: .leading)
                    {
                        withAnimation(.easeInOut) {
                            currentState -= 1
                        }
                    }
                    
                    CustomButton(buttonText: String(localized: "Save"), buttonTextColor: .color2, buttonImage: "flag.pattern.checkered", buttonColor: Color.color1)
                    {
                        withAnimation(.easeInOut) {
                            viewModel.license = license
                            viewModel.brand = brand
                            viewModel.model = model
                            viewModel.fuelType = fuelType
                            viewModel.engineSize = engineSize
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
                .padding(.vertical)
                .padding(.horizontal)
                    
            default:
                Text("Tamamlandı")
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding()
        .onAppear {
            viewModel.fetchBrands()
        }
    }
}

#Preview {
    AracEklemeScreen()
}
