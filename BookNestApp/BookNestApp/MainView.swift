//
//  MainView.swift
//  BookNestApp
//
//  Created by Neslihan Turpcu on 2024-10-05.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Book", systemImage: "book")
                }
            
            // Favorites View
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            
        }
    }
}

#Preview {
    MainView()
}
