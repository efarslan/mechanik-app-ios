//
//  activeJobsCard.swift
//  mechanik
//
//  Created by efe arslan on 8.09.2025.
//

import SwiftUI

struct ActiveJobsCard: View {
    let activeJob: ActiveJobWithCar
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white)
            .overlay(
                VStack (alignment: .leading){
                    //Header and Brand Logo
                    VStack {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(.ultraThickMaterial)
                                .overlay(
                                    Image("\(activeJob.car.brand.lowercased())_logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding(12)
                                )
                                .frame(width: 56, height: 56)
                            
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(activeJob.job.jobTitle)
                                        .foregroundColor(.black)
                                        .font(.title3)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Text("-")
                                        .foregroundColor(.black)
                                    
                                    Text(activeJob.car.license)
                                        .foregroundColor(.black)
                                        .font(.title3)
                                        .lineLimit(1)
                                }
                                
                                Text("\(DateFormatter.localizedString(from: activeJob.job.createdAt, dateStyle: .medium, timeStyle: .none)) (\(timeAgo(from: activeJob.job.createdAt)))")
                                    .font(.footnote)
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                            
                        }
                    }
                    .padding(.bottom, 16)
                    //Image Section
                    if let firstPhoto = activeJob.job.photos.first,
                       let url = URL(string: firstPhoto) {
                        AsyncImage(url: url,
                                   content: { image in
                                       image
                                           .resizable()
                                           .aspectRatio(contentMode: .fill)
                                           .frame(width: UIScreen.main.bounds.width * 0.79,
                                                  height: UIScreen.main.bounds.height * 0.22)
                                           .cornerRadius(32)
                                   },
                                   placeholder: {
                                       RoundedRectangle(cornerRadius: 32)
                                           .fill(Color(.systemGray6))
                                           .frame(width: UIScreen.main.bounds.width * 0.79,
                                                  height: UIScreen.main.bounds.height * 0.22)
                                           .overlay(
                                               ProgressView()
                                           )
                                   }
                        )
                    } else {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(Color(.systemGray6))
                            .frame(width: UIScreen.main.bounds.width * 0.79,
                                   height: UIScreen.main.bounds.height * 0.22)
                            .overlay(
                                VStack {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.secondary)
//                                        .padding()
                                    
                                    Text("No Image Available.")
                                        .foregroundColor(.secondary)
                                }
                                    .padding(24)
                            )
                    }
                    //Other Infos
                    HStack(spacing: 16) {
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "wrench.and.screwdriver")
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.7))

                            Text("\(activeJob.job.selectedSubJobs.count) task")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "gauge.open.with.lines.needle.67percent.and.arrowtriangle.and.car")
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.7))

                            Text(activeJob.job.mileage)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                    }
                }
                    .padding(.horizontal)
            )
            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.35)
            .padding()
            
    }
    
    // MARK: - Time Ago Function

    func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    MainScreen(isTabBarHidden: .constant(false))
}

#Preview {
    MainScreen(isTabBarHidden: .constant(false))
        .environment(\.locale, .init(identifier: "en"))

}
