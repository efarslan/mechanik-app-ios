//
//  PhotoGridComponent.swift
//  mechanik
//
//  Created by efe arslan on 28.08.2025.
//

import SwiftUI
import PhotosUI

struct PhotoGridComponent: View {
    @Binding var selectedImages: [UIImage]
    let maxImages: Int
    
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    init(selectedImages: Binding<[UIImage]>, maxImages: Int = 6) {
        self._selectedImages = selectedImages
        self.maxImages = maxImages
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                ForEach(0..<maxImages, id: \.self) { index in
                    if index < selectedImages.count {
                        ZStack {
                            Image(uiImage: selectedImages[index])
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .cornerRadius(12)
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        selectedImages.remove(at: index)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }
                                    .padding(4)
                                }
                                Spacer()
                            }
                        }
                    } else {
                        // Fotoğraf ekleme butonu
                        Button(action: {
                            showingActionSheet = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .aspectRatio(1, contentMode: .fit)
                                Image(systemName: "photo.badge.plus")
                                    .font(.title)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: selectedItems) { oldItems, newItems in
            Task {
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImages.append(image)
                    }
                }
                selectedItems = [] // Selection'ı sıfırla
            }
        }
        .confirmationDialog("Add Picture", isPresented: $showingActionSheet) {
            Button("Camera") {
                sourceType = .camera
                showingImagePicker = true
            }
            Button("Camera Roll") {
                sourceType = .photoLibrary
                showingImagePicker = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(sourceType: sourceType) { image in
                selectedImages.append(image)
            }
        }
    }
}

// ImagePicker için UIViewControllerRepresentable
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

//#Preview {
//    addNewJob()
//}
