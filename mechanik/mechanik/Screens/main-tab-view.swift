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
                    Text("Ana Sayfa")
                }
            
            CarsScreen()
                .tabItem {
                    Image(systemName: "car")
                    Text("Araçlar")
                }
            
            EmptyView()
                .tabItem {
                    Image(systemName: "ellipsis.circle.fill")
                    Text("...")
                }
        }
    }
}

#Preview {
    main_tab_view()
}
