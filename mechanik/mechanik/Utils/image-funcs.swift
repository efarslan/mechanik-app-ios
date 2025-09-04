//
//  image-funcs.swift
//  mechanik
//
//  Created by efe arslan on 4.09.2025.
//

import SwiftUI
import CryptoKit

final class ImageCacheManager: ObservableObject {
    static let shared = ImageCacheManager()
    
    @Published var previewURL: URL?
    @Published var showingPreview = false
    
    private init() {}
    
    
    func enhancedAsyncImageView(url: String) -> some View {
        let cachedURL = getCachedImageURL(for: url)
        
        return Group {
            if let cachedURL = cachedURL, FileManager.default.fileExists(atPath: cachedURL.path) {
                // Download from cache
                Image(uiImage: UIImage(contentsOfFile: cachedURL.path) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                // Download from firebase storage
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 120, height: 120)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .onAppear {
                                // if success save to cache
                                self.cacheImage(from: url)
                            }
                    case .failure(_):
                        Rectangle()
                            .fill(Color.red.opacity(0.3))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "photo.badge.exclamationmark")
                                    .foregroundColor(.gray)
                                    .font(.largeTitle)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .onTapGesture {
            self.handleImageTap(url: url)
        }
    }
    
    func generateUniqueFileName(from urlString: String) -> String {
        guard let url = URL(string: urlString) else {
            return "invalid_url.jpg"
        }
        
        // hashing
        let inputData = Data(urlString.utf8)
        let hashed = Insecure.MD5.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        
        // save file extension
        let pathExtension = url.pathExtension.isEmpty ? "jpg" : url.pathExtension
        return "\(hashString).\(pathExtension)"
    }
    
    // get cache url
    func getCachedImageURL(for urlString: String) -> URL? {
        do {
            let cacheDirectory = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ).appendingPathComponent("ImageCache", isDirectory: true)
            
            let fileName = generateUniqueFileName(from: urlString)
            return cacheDirectory.appendingPathComponent(fileName)
        } catch {
            return nil
        }
    }
    
    // save image to cache (if asyncImage is in succes state
    func cacheImage(from urlString: String) {
        Task {
            await cacheImageAsync(from: urlString)
        }
    }
    
    // async cahce
    func cacheImageAsync(from urlString: String) async {
        guard let url = URL(string: urlString),
              let cachedURL = getCachedImageURL(for: urlString) else {
            return
        }
        
        // if file exist dont cache
        if FileManager.default.fileExists(atPath: cachedURL.path) {
            print("Dosya zaten cache'te mevcut: \(cachedURL.path)")
            return
        }
        
        do {
            // create cache directory
            let cacheDirectory = cachedURL.deletingLastPathComponent()
            if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
                try FileManager.default.createDirectory(
                    at: cacheDirectory,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }
            
            // download image
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  !data.isEmpty else {
                throw URLError(.badServerResponse)
            }
            
            // save to cache
            try data.write(to: cachedURL)
            print("Resim cache'e kaydedildi: \(cachedURL.path)")
            
        } catch {
            print("Cache kaydetme hatası: \(error.localizedDescription)")
        }
    }
    
    // image tap
    func handleImageTap(url: String) {
        if let cachedURL = getCachedImageURL(for: url),
           FileManager.default.fileExists(atPath: cachedURL.path) {
            // Cache'te varsa direkt göster
            self.previewURL = cachedURL
            self.showingPreview = true
        } else {
            // Cache'te yoksa indir ve göster
            downloadAndPreviewImage(from: url)
        }
    }
    
    // download for quicklook
    func downloadAndPreviewImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Geçersiz URL: \(urlString)")
            return
        }
        
        Task {
            do {
                if let cachedURL = getCachedImageURL(for: urlString),
                   FileManager.default.fileExists(atPath: cachedURL.path) {
                    // Cache'te var, direkt göster
                    await MainActor.run {
                        self.previewURL = cachedURL
                        self.showingPreview = true
                    }
                    return
                }
                
                // Cache'te yok, indir
                await cacheImageAsync(from: urlString)
                
                // İndirme sonrası göster
                if let cachedURL = getCachedImageURL(for: urlString),
                   FileManager.default.fileExists(atPath: cachedURL.path) {
                    await MainActor.run {
                        self.previewURL = cachedURL
                        self.showingPreview = true
                    }
                }
                
            } catch {
                print("Preview için indirme hatası: \(error.localizedDescription)")
            }
        }
    }
    
    func clearImageCache() {
        do {
            let cacheDirectory = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ).appendingPathComponent("ImageCache", isDirectory: true)
            
            if FileManager.default.fileExists(atPath: cacheDirectory.path) {
                try FileManager.default.removeItem(at: cacheDirectory)
                print("Image cache temizlendi")
            }
        } catch {
            print("Cache temizleme hatası: \(error)")
        }
    }
    
    func getCacheSize() -> String {
        do {
            let cacheDirectory = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ).appendingPathComponent("ImageCache", isDirectory: true)
            
            let resourceKeys: [URLResourceKey] = [.fileSizeKey]
            let enumerator = FileManager.default.enumerator(
                at: cacheDirectory,
                includingPropertiesForKeys: resourceKeys,
                options: [.skipsHiddenFiles],
                errorHandler: nil
            )
            
            var totalSize: Int64 = 0
            while let fileURL = enumerator?.nextObject() as? URL {
                let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                totalSize += Int64(resourceValues.fileSize ?? 0)
            }
            
            let formatter = ByteCountFormatter()
            formatter.countStyle = .file
            return formatter.string(fromByteCount: totalSize)
            
        } catch {
            return "Error"
        }
    }
}
