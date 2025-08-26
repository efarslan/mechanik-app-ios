//
//  car-details.swift
//  mechanik
//
//  Created by efe arslan on 26.08.2025.
//

import SwiftUI

struct CarDetails: View {
    let car: Car
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                history
                newJob
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .background(Color(.systemBackground))
        .navigationTitle(car.license)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Header
    private var header: some View {
        VStack (alignment: .leading) {
            detailBox(brand: car.brand, model: car.model, year: "2025", engine: car.engineSize, fuel: car.fuelType, chasis: car.chasisNo)
            
            HStack {
                smallDetailBox(icon: "newspaper", title: "Notes", value: car.notes.isEmpty ? "-" : car.notes)
                
                smallDetailBox(icon: "person", title: "Owner", value: "\(car.carOwner) \n \(car.ownerPhoneNumber)")
            }
        }
        
        
        //                HStack(spacing: 8) {
        //                    pill("11.12.2003 - 25 Record")
        //                }
        //                //TODO: Son düzenleme ve toplam işlem kaydı yazacak.
        
    }
    
    // MARK: - History
    private var history: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .frame(maxWidth: .infinity, minHeight: 300)
            .overlay(
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Service History")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("See All") {
                            //TODO: Tüm işlemleri gösterme işlevi eklenecek.
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    //TODO: not-found görseli eklenecek. / En güncel kayıt en üstte yer alacak.
                    
                    historyCard(jobName: "Oil Change", date: Date())
//                    historyCard(jobName: "Oil Change", date: Date())
//                    historyCard(jobName: "Oil Change", date: Date())

                }
            )
    }
    
    //MARK: - New Job
    private var newJob: some View {
        CustomButton(buttonText: "Add New Job", buttonTextColor: Color.color2, buttonImage: "plus", buttonColor: Color.color1) {
            //TODO: Buton islevi eklenecek.
        }
    }

    // MARK: - Helpers
    private func pill(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Capsule().fill(Color.secondary.opacity(0.15)))
    }
}

// MARK: - DateFormatter helper
extension DateFormatter {
    static let carDate: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
}

#Preview {
    NavigationStack {
        CarDetails(
            car: Car(
                license: "34TST34",
                brand: "Volkswagen",
                model: "Golf",
                fuelType: "Petrol",
                engineSize: "1.2",
                chasisNo: "XYZ123456789",
                carOwner: "Tester",
                ownerPhoneNumber: "5551234567",
                notes: "Regular maintenance done. Tire rotation due in 5,000 km.",
                createdAt: Date()
            )
        )
        .padding()
    }
}
