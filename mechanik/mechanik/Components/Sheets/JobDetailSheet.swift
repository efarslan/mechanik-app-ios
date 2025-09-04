import SwiftUI
import QuickLook
import CryptoKit

struct JobDetailSheet: View {
    let job: Job
    @State private var scrollOffset: CGFloat = 0
    @State private var selectedImageURL: String? = nil
    @State private var showImageViewer = false
    @StateObject private var cacheManager = ImageCacheManager.shared
    @State private var jobStatus = ""
//    @State private var previewURL: URL?
//    @State private var showingPreview = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        InfoRow(
                            title: "Job Started",
                            value: DateFormatter.localizedString(
                                from: job.createdAt,
                                dateStyle: .medium,
                                timeStyle: .short
                            )
                        )
                        Spacer()
                        InfoRow(title: "Job Finished", value: "30 Ağu 2025 19:30")
                    }
                    Text(job.notes.isEmpty ? "No note added." : job.notes)
                        .foregroundColor(Color(.systemGray))
                        .padding(.top, 25)
                    
                    Divider()
                    
                    HStack(spacing: 16) {
                        VStack{
                            InfoRow(title: "Job Title", value: job.jobTitle)
                            Spacer()
                        }
                        Spacer()
                        VStack{
                            InfoRow(title: "Mileage", value: job.mileage)
                            Spacer()
                        }
                        Spacer()
                        VStack {
                            InfoRow(title: "Labor C.", value: "2000.00 ₺")
                            Spacer()
                        }
                    }
                    
                    if !job.selectedSubJobs.isEmpty {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.ultraThinMaterial)
                            .frame(maxWidth: .infinity, minHeight: 300)
                            .overlay(
                                VStack {
                                    Button(action: {
                                        scrollUp()
                                    }) {
                                        Image(systemName: "chevron.up")
                                            .foregroundColor(scrollOffset > 0 ? .primary : .gray)
                                            .font(.title2)
                                            .padding(8)
                                            .background(Circle().fill(.regularMaterial))
                                    }
                                    .disabled(scrollOffset <= 0)
                                    .padding(.top, 8)
                                    
                                    ScrollViewReader { proxy in
                                        ScrollView {
                                            LazyVStack(spacing: 12) {
                                                ForEach(Array(job.selectedSubJobs.enumerated()), id: \.element) { index, subJobName in
                                                    jobCard(
                                                        sjName: subJobName,
                                                        partName: job.brandText[subJobName] ?? "-",
                                                        partQty: job.quantity[subJobName] ?? 0,
                                                        partPrice: job.unitPrice[subJobName] ?? 0.0
                                                    )
                                                    .padding(.horizontal)
                                                    .frame(width: UIScreen.main.bounds.width * 0.9)
                                                    .id(index)
                                                }
                                            }
                                        }
                                        .scrollDisabled(true)
                                        .onChange(of: scrollOffset) { _, newValue in
                                            let targetIndex = max(0, min(Int(newValue), job.selectedSubJobs.count - 1))
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                proxy.scrollTo(targetIndex, anchor: .top)
                                            }
                                        }
                                    }
                                    .frame(maxHeight: 250)
                                    
                                    Button(action: {
                                        scrollDown()
                                    }) {
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(scrollOffset < CGFloat(job.selectedSubJobs.count - 1) ? .primary : .gray)
                                                .font(.title2)
                                                .padding(8)
                                                .background(Circle().fill(.regularMaterial))
                                    }
                                    .disabled(scrollOffset >= CGFloat(job.selectedSubJobs.count - 1))
                                    .padding(.bottom, 8)
                                }
                            )
                    }
                    
                    HStack {
                        Spacer()
                        Text("Parts C. : \(String(format: "%.2f ₺", totalPartsCost))")
                            .foregroundColor(Color(.systemGray))
                    }
                    
                    if !job.photos.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(job.photos, id: \.self) { url in
                                    cacheManager.enhancedAsyncImageView(url: url)
                                        .onTapGesture {
                                            cacheManager.handleImageTap(url: url)
                                        }
                                }
                            }
                        }
                        .quickLookPreview(
                            $cacheManager.previewURL,
                            in: cacheManager.showingPreview
                                ? [cacheManager.previewURL].compactMap { $0 }
                                : []
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("\(job.id ?? "") (\(job.jobStatus == 0 ? NSLocalizedString("In Progress", comment: "") : NSLocalizedString("Completed", comment: "")))")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func scrollUp() {
        scrollOffset = max(0, scrollOffset - 1)
    }
    
    private func scrollDown() {
        let maxOffset = CGFloat(job.selectedSubJobs.count - 1)
        scrollOffset = min(maxOffset, scrollOffset + 1)
    }
    
    private var totalPartsCost: Double {
        job.selectedSubJobs.reduce(0) { sum, subJobName in
            let qty = job.quantity[subJobName] ?? 0
            let price = job.unitPrice[subJobName] ?? 0.0
            return sum + (Double(qty) * price)
        }
    }
    
 
}

#Preview {
    JobDetailSheet(
        job: Job(
            id: "3008-A1B2C3",
//            jobType: "Maintenance",
            jobTitle: "Routine Check Routine Check Routine CheckRoutine C",
            mileage: "120.000",
            notes: "Changed oil, replaced filters, and general inspection done.",
            selectedSubJobs: ["Oil Change", "Filter Replacement", "Inspection", "Timing Belt", "Brake Check", "Battery Test"],
            brandText: ["oil": "Castrol", "filter": "Bosch", "Timing Belt": "Timing Belt"],
            quantity: ["oil": 4, "filter": 1, "Timing Belt": 1],
            unitPrice: ["oil": 150.0, "filter": 80.0, "Timing Belt": 1000.0],
            photos: ["https://firebasestorage.googleapis.com/v0/b/mechanik-51c7d.firebasestorage.app/o/cars%2FmockId%2Fjobs%2F2396D149-791E-4FAA-BE4C-531431D03883.jpg?alt=media&token=eb2369ca-ab83-40eb-a227-f9cff5c29e61"],
            createdAt: Date(),
            jobStatus: 0
        )
    )
}
