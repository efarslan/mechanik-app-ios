//
//  RootView.swift
//  mechanik
//
//  Created by efe arslan on 19.08.2025.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @State private var isLoggedIn = false

    var body: some View {
        Group {
            if isLoggedIn {
                main_tab_view()
            } else {
                LoginScreen()
            }
        }
        .onAppear {
            isLoggedIn = Auth.auth().currentUser != nil
        }
    }
}
