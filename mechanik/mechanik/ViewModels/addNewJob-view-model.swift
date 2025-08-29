//
//  addNewJob-view-model.swift
//  mechanik
//
//  Created by efe arslan on 29.08.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AddJobViewModel: ObservableObject {
    @Published var step: Int = 1
    @Published var selectedJob: String = "Maintenance"
    @Published var mileage: String = ""
    @Published var notes: String = ""
    @Published var selectedSubJobs: [String] = []
    @Published var brandText: [String: String] = [:]
    @Published var quantityText: [String: String] = [:]
    @Published var unitPriceText: [String: String] = [:]
    @Published var selectedImages: [UIImage] = []

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    func saveJob(forCarId carId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No user logged in")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])))
            return
        }
        
        Task {
            do {
                var photoURLs: [String] = []
                for image in selectedImages {
                    if let url = try await uploadImage(image, carId: carId) {
                        photoURLs.append(url)
                    }
                }

                let job = Job(
                    jobType: selectedJob,
                    mileage: mileage,
                    notes: notes,
                    selectedSubJobs: selectedSubJobs,
                    brandText: brandText,
                    quantityText: quantityText,
                    unitPriceText: unitPriceText,
                    photos: photoURLs,
                    createdAt: Date() // ✅ Bu satırı ekleyin
                )
                
                let jobId = generateJobId()
                try await db.collection("users")
                    .document(userId)
                    .collection("cars")
                    .document(carId)
                    .collection("jobs")
                    .document(jobId)
                    .setData(job.dictionary)

                print("Job saved successfully for car \(carId)")
                completion(.success(()))
            } catch {
                print("Job save failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    private func uploadImage(_ image: UIImage, carId: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else { return nil }
        let imageId = UUID().uuidString
        let ref = storage.reference().child("cars/\(carId)/jobs/\(imageId).jpg")
        _ = try await ref.putDataAsync(imageData)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
    
    private func generateJobId() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMM"
        let datePart = formatter.string(from: date)
        
        let chars = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let randomPart = (0..<6).compactMap { _ in chars.randomElement() }.map { String($0) }.joined()
        
        return "\(datePart)-\(randomPart)"
    }
}
