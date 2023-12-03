//
//  NetflixApp.swift
//  Netflix
//
//  Created by Azoz Salah on 01/02/2023.
//

import SwiftUI

@main
struct NetflixApp: App {
    
    @StateObject private var viewModel = NetflixViewModel()
    
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .preferredColorScheme(.dark)
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
                .environmentObject(viewModel)
        }
    }
}
