//
//  main-tab-view.swift
//  mechanik
//
//  Created by efe arslan on 19.08.2025.
//

import SwiftUI

struct main_tab_view: View {
    @State private var isTabBarHidden = false
    var body: some View {
        NavigationStack {
            TabView {
                MainScreen(isTabBarHidden: $isTabBarHidden)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                CarsScreen(isTabBarHidden: $isTabBarHidden)
                    .tabItem {
                        Image(systemName: "car")
                        Text("Cars")
                    }
                
                EmptyView()
                    .tabItem {
                        Image(systemName: "ellipsis.circle.fill")
                        Text("...")
                    }
            }
        }
    }
}

#Preview {
    main_tab_view()
}
