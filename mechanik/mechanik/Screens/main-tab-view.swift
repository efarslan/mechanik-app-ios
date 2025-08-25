//
//  main-tab-view.swift
//  mechanik
//
//  Created by efe arslan on 19.08.2025.
//

import SwiftUI

struct main_tab_view: View {
    var body: some View {
        TabView {
            MainScreen()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            CarsScreen()
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    main_tab_view()
}
