//
//  detail-box.swift
//  mechanik
//
//  Created by efe arslan on 26.08.2025.
//

import SwiftUI

struct detailBox: View {
    let brand: String
    let model: String
    var year: Int
    var engine: String
    var fuel: String
    var chasis: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .frame(maxWidth: .infinity, minHeight: 275)
            .overlay(
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(title: "Brand", value: brand)
                        InfoRow(title: "Model", value: model)
                        InfoRow(title: "Year", value: String(year))
                        InfoRow(title: "Engine", value: "\(engine) \(fuel)")
                        InfoRow(title: "Chasis Number", value: chasis)
                    }
                    .padding(.horizontal)
                    Spacer()
                    
                    Image("\(brand.lowercased())_logo")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                }
            )
    }
}

struct InfoRow: View {
    let title: LocalizedStringKey
    var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct smallDetailBox: View {
    let icon: String
    let title: LocalizedStringKey
    var value: String
    
    var body: some View {
            RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
//            .frame(maxWidth: 165, minHeight: 150)
            .frame(maxWidth: .infinity, minHeight: 150)
            .overlay(
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: icon)
                            .font(.title3)
                            .foregroundColor(.primary)
                        
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    Text(value)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal)
                    .padding(.vertical)
                )
    }
}

struct historyCard: View {
    let jobName: String
    let date: Date
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color(.systemBackground))
            .frame(maxWidth: .infinity, minHeight: 70)
            .overlay(
                HStack {
                    VStack (alignment: .leading, spacing: 4) {
                        Text(jobName)
                            .font(.headline)
//                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        
                        Text(DateFormatter.carDate.string(from: date))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Button(action: {
                        // TODO: Job detayına git
                    }) {
                        Image(systemName: "arrow.up.right")
                            
                    }
                }
                    .padding(.horizontal)
                    .padding(.vertical, 8)

            )
            .padding(.horizontal)

    }
}

//#Preview {
//    detailBox(details: "Detail Detail Detail Detail Detail Detail ", icon: "newspaper", title: "Notes")
//}

#Preview {
    NavigationStack {
        CarDetails(
            car: Car(
                id: "34TST34",
                license: "34TST34",
                brand: "Volkswagen",
                model: "Golf",
                year: 2025,
                fuelType: "Petrol",
                engineSize: "1.2",
                chasisNo: "XYZ123456789",
                carOwner: "Tester",
                ownerPhoneNumber: "5551234567",
                notes: "Regular maintenance done. Tire rotation due in 5,000 km. ",
                createdAt: Date()
            )
        )
        .padding()
    }
}
