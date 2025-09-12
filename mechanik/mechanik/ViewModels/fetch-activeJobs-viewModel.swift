//
//  fetch-activeJobs-viewModel.swift
//  mechanik
//
//  Created by efe arslan on 8.09.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class ActiveJobsViewModel: ObservableObject {
    @Published var activeJobsWithCars: [ActiveJobWithCar] = []
    private let db = Firestore.firestore()

    func fetchActiveJobs() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ No user logged in")
            return
        }
        print("✅ Logged in userId: \(userId)")
        
        
        db.collection("users")
          .document(userId)
          .collection("cars")
          .getDocuments { [weak self] carSnapshot, error in
              if let error = error {
                  print("❌ Error fetching cars: \(error.localizedDescription)")
              }
              print("Cars fetched: \(carSnapshot?.documents.count ?? 0)")

              guard let self = self, let carDocs = carSnapshot?.documents else { return }

              for carDoc in carDocs {
                  guard let car = try? carDoc.data(as: Car.self) else {
                      print("❌ Failed to decode car document")
                      continue
                  }

                  print("Fetching jobs for car \(car.license)")

                  // Her aracın jobs koleksiyonunu filtrele
                  carDoc.reference.collection("jobs")
                      .whereField("jobStatus", isEqualTo: 0)
                      .getDocuments { jobSnapshot, _ in
                          guard let jobDocs = jobSnapshot?.documents else {
                              print("No jobs found for car \(car.license)")
                              return
                          }
                          print("Jobs found for car \(car.license): \(jobDocs.count)")

                          let jobsWithCar = jobDocs.compactMap { jobDoc -> ActiveJobWithCar? in
                              guard let job = try? jobDoc.data(as: Job.self) else { return nil }
                              return ActiveJobWithCar(id: jobDoc.documentID, job: job, car: car)
                          }

                          DispatchQueue.main.async {
                              for jobWithCar in jobsWithCar {
                                  if !self.activeJobsWithCars.contains(where: { $0.id == jobWithCar.id }) {
                                      self.activeJobsWithCars.append(jobWithCar)
                                  }
                              }
                              print("Car: \(car.license), Jobs found: \(jobDocs.count)")
                          }
                      }
              }
          }
    }
}
