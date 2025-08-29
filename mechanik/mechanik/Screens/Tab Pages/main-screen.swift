//
//  main-screen.swift
//  mechanik
//
//  Created by efe arslan on 19.08.2025.
//

import SwiftUI
import FirebaseFirestore

struct MainScreen: View {
    @Binding var isTabBarHidden: Bool
    var body: some View {
        Text("Hello, World!")
            .foregroundColor(Color.customGreen)
    }
}


#Preview {
    MainScreen(isTabBarHidden: .constant(false))
}
