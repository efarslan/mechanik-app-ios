//
//  car-details.swift
//  mechanik
//
//  Created by efe arslan on 26.08.2025.
//

import SwiftUI
import FirebaseAuth

struct CarDetails: View {
    let car: Car
    @State private var showAddJob = false
    @StateObject private var jobsViewModel = JobsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedJob: Job?

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                header
                history
                newJob
            }
            .padding()
        }
//        .refreshable {
//            guard let carId = car.id else { return }
//            jobsViewModel.fetchJobs(for: carId)
//        }
        .scrollIndicators(.hidden)
        .background(Color(.systemBackground))
        .navigationTitle(car.license)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                        )
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    //TODO: Düzenleme vb.
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.primary)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                        )
                }
            }
        }
        .onAppear {
            guard let carId = car.id else {
                print("❌ Car ID is NIL!")
                return
            }
            print(car.fuelType)
            
            jobsViewModel.fetchJobs(for: carId)
        }
        // Hidden NavigationLink for navigation to addNewJob
        NavigationLink(
            destination: addNewJob(car: car),
            isActive: $showAddJob,
            label: { EmptyView() }
        )
        .hidden()
    }

    // MARK: - Header
    private var header: some View {
        VStack (alignment: .center) {
            detailBox(brand: car.brand, model: car.model, year: car.year, engine: car.engineSize, fuel: NSLocalizedString(car.fuelType, comment: ""), chasis: car.chasisNo)
            
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
            .padding(.top)
            
            if jobsViewModel.jobs.isEmpty {
                VStack {
                    Text("No Jobs Found.")
                        .foregroundColor(.secondary)
                    Spacer(minLength: 50)
                }
                .frame(minHeight: 100)
                .padding()
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(jobsViewModel.jobs.sorted { $0.createdAt > $1.createdAt }.prefix(3)) { job in
                        historyCard(jobName: job.jobTitle, date: job.createdAt) {
                            selectedJob = job
                        }
                    }
                    .sheet(item: $selectedJob) { job in
                        JobDetailSheet(job: job)
                    }
                }
                .padding(.bottom)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
        )
    }
    //MARK: - New Job
    private var newJob: some View {
        CustomButton(buttonText: "Add New Job", buttonTextColor: Color.color2, buttonImage: "plus", buttonColor: Color.color1) {
            showAddJob = true
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
                id: "34TST34",
                license: "34TST34",
                brand: "Volkswagen",
                model: "Golf",
                year: 2025,
                fuelType: "Petrol",
                engineSize: "1.2",
                chasisNo: "XYZ123456789",
                carOwner: "Tester",
                ownerPhoneNumber: "5551",
                notes: "Regular maintenance done.",
                createdAt: Date()
            )
        )
        .padding()
    }
    .environment(\.locale, .init(identifier: "tr"))
}

#Preview {
    NavigationStack {
        CarDetails(
            car: Car(
                id: "34TS34",
                license: "34TST34",
                brand: "Volkswagen",
                model: "Golf",
                year: 2025,
                fuelType: "Petrol",
                engineSize: "1.2",
                chasisNo: "XYZ123456789",
                carOwner: "Tester",
                ownerPhoneNumber: "5551",
                notes: "Regular maintenance done.",
                createdAt: Date()
            )
        )
        .padding()
    }
    .environment(\.locale, .init(identifier: "eng"))
}

#Preview {
    CarsScreen(isTabBarHidden: .constant(false))
}
