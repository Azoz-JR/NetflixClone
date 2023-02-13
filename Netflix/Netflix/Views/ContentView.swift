//
//  ContentView.swift
//  Netflix
//
//  Created by Azoz Salah on 01/02/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NetflixViewModel()
    
    var body: some View {
        TabView {
            Group {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                ComingSoonView()
                    .tabItem {
                        Label("Coming Soon", systemImage: "play.rectangle.on.rectangle")
                    }
                
                DownloadView()
                    .tabItem {
                        Label("Downloads", systemImage: "arrow.down.to.line")
                    }
            }
            .toolbar(.visible, for: .tabBar)
            .toolbarBackground(Color.black.opacity(0.1), for: .tabBar)
            .environmentObject(viewModel)
            .onAppear {
                Task {
                    await viewModel.fetchTrendingMovies()
                    await viewModel.fetchTrendingTvs()
                    await viewModel.fetchPopularMovies()
                    await viewModel.fetchUpcomingMovies()
                    await viewModel.fetchTopRatedMovies()
                    await viewModel.fetchTopRatedTvs()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
