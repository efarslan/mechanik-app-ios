//
//  add-new-job.swift
//  mechanik
//
//  Created by efe arslan on 26.08.2025.
//

import SwiftUI
import PhotosUI

struct addNewJob: View {
    let car: Car

    @Environment(\.presentationMode) var presentationMode

    @State private var step = 1

    @StateObject var viewModel = AddJobViewModel()
    
    @State private var showMileageError: Bool? = nil


    
    let jobList = ["Maintenance", "Engine / Mechanical", "Transmission / Clutch", "Suspension", "Brakes", "Electrical", "Cooling System", "Exhaust System", "Other"]
    
    let quickJobs: [String: [String]] = [
        "Maintenance": ["Oil", "Oil Filter", "Air Filter", "Pollen Filter", "Fuel Filter"],
        "Engine / Mechanical": ["Timing Belt Replacement", "V-Belt Replacement", "Water Pump", "Injector Service", "Turbo", "Engine Mount"],
        "Transmission / Clutch": ["Clutch Kit Replacement", "Transmission Oil Change", "Flywheel Replacement"],
        "Suspension": ["Shock Absorber", "Control Arm", "Swing Arm", "Ball Joint", "Tie Rod End"],
        "Brakes": ["Brake Pads", "Brake Disc", "Brake Fluid Change", "Brake Calipers"],
        "Electrical": ["Battery", "Starter Motor", "Alternator", "Spark Plug Replacement"],
        "Cooling System": ["Radiator Replacement", "Thermostat Replacement", "Hose Replacement", "Coolant Replacement"],
        "Exhaust System": ["DPF Cleaning", "Catalytic Converter Cleaning", "Oxygen Sensor Replacement", "Manifold Gasket", "Mufflers"]
    ]
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                if step == 1 {
                    jobDetailsView
                } else if step == 2 {
                    quickJobDetailsView
                }
                else if step == 3 {
                    addPhotosView
                }
            }
            .padding()
            .scrollIndicators(.hidden)
            .background(Color(.systemBackground))
            .navigationTitle("Add New Job")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }

        HStack {
            CustomButton(buttonText: step > 1 ? "Back" : "Cancel", buttonTextColor: .white, buttonImage: step > 1 ? "chevron.left" : "xmark", buttonColor: step > 1 ? .color2 : Color.red, imagePosition: .leading) {
                withAnimation(.easeInOut) {
                    if step > 1 {
                        step -= 1
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
            CustomButton(buttonText: step >= 3 ? "Save" : "Next", buttonTextColor: .color2, buttonImage: "chevron.right", buttonColor: .color1) {
                withAnimation(.easeInOut) {
                    if step < 3 {

                        if viewModel.mileage.trimmingCharacters(in: .whitespaces).isEmpty {
                            showMileageError = true
                        } else {
                            showMileageError = false
                            step += 1
                        }
                    } else if step == 3 {
                        if let carId = car.id {
                            viewModel.saveJob(forCarId: carId)
                            { result in
                                switch result {
                                case .success:
                                    print("Job saved successfully")
                                    DispatchQueue.main.async {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                case .failure(let error):
                                    print("Job save failed: \(error)")
                                }
                            }
                        } else {
                            print("Error: Car ID is nil")
                        }
                    }
                }
            }
        }
        .padding()

    }
    //MARK: - Job Details
    private var jobDetailsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            //TODO: Görsel eklenebilir.
            
            
            CustomPicker(
                selectedItem: $viewModel.selectedJob,
                items: jobList,
                placeholder: viewModel.selectedJob
            )
            
            
            if let subJobs = quickJobs[viewModel.selectedJob], !subJobs.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(subJobs, id: \.self) { subJob in
                            Button(action: {
                                if viewModel.selectedSubJobs.contains(subJob) {
                                    viewModel.selectedSubJobs.removeAll { $0 == subJob }
                                } else {
                                    viewModel.selectedSubJobs.append(subJob)
                                }
                            }) {
                                Text(LocalizedStringKey(subJob))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(viewModel.selectedSubJobs.contains(subJob) ? Color.color1 : Color.gray.opacity(0.2))
                                    .foregroundColor(viewModel.selectedSubJobs.contains(subJob) ? Color.color2 : Color.primary)
                                    .cornerRadius(15)
                            }
                        }
                    }
                }

            }
            
            let isMetric = Locale.current.measurementSystem == "Metric"
            customTextField(placeholder: isMetric ? "Kilometers" : "Miles", text: $viewModel.mileage, isRequired: true, showError: $showMileageError)
                .padding(.top)

            customEditor(text: $viewModel.notes, placeholder: String(localized: "Notes"), characterLimit: 180)
                .frame(minHeight: 170)
        }
    }
    //MARK: - Quick Job Details / Part qty, price, name
    private var quickJobDetailsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Selected Quick Jobs")
                .font(.headline)
            if viewModel.selectedSubJobs.isEmpty {
                Text("No quick jobs selected.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.selectedSubJobs, id: \.self) { subJob in
                    SubJobBox(
                        jobName: subJob,
                        brand: Binding(
                            get: { viewModel.brandText[subJob] ?? "" },
                            set: { viewModel.brandText[subJob] = $0 }
                        ),
                        quantityText: Binding(
                            get: { viewModel.quantityText[subJob] ?? "" },
                            set: { viewModel.quantityText[subJob] = $0 }
                        ),
                        unitPriceText: Binding(
                            get: { viewModel.unitPriceText[subJob] ?? "" },
                            set: { viewModel.unitPriceText[subJob] = $0 }
                        )
                    )
                    .padding(.vertical, 4)
                }
            }
        }
    }
    
    //MARK: - Add Photos
    private var addPhotosView: some View {
        VStack(alignment: .leading) {
            PhotoGridComponent(selectedImages: $viewModel.selectedImages, maxImages: 6)
        }
    }
}

    
    // MARK: - Previews
    #Preview {
        addNewJob(car: Car(
            id: "mockId",
            license: "34ABC123",
            brand: "Toyota",
            model: "Corolla",
            year: 2025,
            fuelType: "Gasoline",
            engineSize: "1.6",
            chasisNo: "ABC123456789",
            carOwner: "John Doe",
            ownerPhoneNumber: "5551234567",
            notes: "Test notes",
//            year: 2020
        ))
        .environment(\.locale, .init(identifier: "tr"))
    }

#Preview {
    addNewJob(car: Car(
        id: "mockId",
        license: "34ABC123",
        brand: "Toyota",
        model: "Corolla",
        year: 2025,
        fuelType: "Gasoline",
        engineSize: "1.6",
        chasisNo: "ABC123456789",
        carOwner: "John Doe",
        ownerPhoneNumber: "5551234567",
        notes: "Test notes",
//            year: 2020
    ))
            .environment(\.locale, .init(identifier: "en"))
    }
