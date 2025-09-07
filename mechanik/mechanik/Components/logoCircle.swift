import SwiftUI

struct circleLogo: View {
    let brand: String?
    let plateNumber: String
    let useBrandLogo: Bool

    var body: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Group {
                        if useBrandLogo, let brand = brand,
                           UIImage(named: "\(brand.lowercased())_logo") != nil {
                            Image("\(brand.lowercased())_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(12)
                        } else {
                            Image(systemName: "car.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .padding(16)
                        }
                    }
                )
                .frame(width: 72, height: 72)
            Text(plateNumber)
                .font(.headline)
        }
    }
}

#Preview {
    circleLogo(brand: "toyota", plateNumber: "34ABC123", useBrandLogo: true)
}

#Preview {
    MainScreen(isTabBarHidden: .constant(false))
}
