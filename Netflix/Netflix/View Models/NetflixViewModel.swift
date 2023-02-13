//
//  NetflixViewModel.swift
//  Netflix
//
//  Created by Azoz Salah on 12/02/2023.
//

import Foundation

class NetflixViewModel: ObservableObject {
    
    let loader = APICaller()
    
    @Published private(set) var trendingMovies: [Movie] = []
    @Published private(set) var trendingTvs: [Tv] = []
    @Published private(set) var upcomingMovies: [Movie] = []
    @Published private(set) var popularMovies: [Movie] = []
    @Published private(set) var topRatedMovies: [Movie] = []
    @Published private(set) var topRatedTvs: [Tv] = []
    @Published private(set) var searchedMovies: [Movie] = []
    @Published private(set) var searchedTvs: [Tv] = []
    @Published private(set) var selectedShowVideoElement: VideoElement = VideoElement.example
    @Published private(set) var downloadedMovies: [Movie]
    @Published private(set) var downloadedTVs: [Tv]
    
    private let savedMoviesPath = getDocumentsDirectory().appending(path: "Movies")
    private let savedTVsPath = getDocumentsDirectory().appending(path: "TVs")
    
    init() {
        do {
            let moviesData = try Data(contentsOf: savedMoviesPath)
            let tvsData = try Data(contentsOf: savedTVsPath)
            
            let decodedMovies = try JSONDecoder().decode([Movie].self, from: moviesData)
            downloadedMovies = decodedMovies
            let decodedTvs = try JSONDecoder().decode([Tv].self, from: tvsData)
            downloadedTVs = decodedTvs
            return
        } catch {
            print("Failed loading data \(error.localizedDescription)")
        }
        
        downloadedMovies = []
        downloadedTVs = []
    }
    
    func fetchTrendingMovies() async  {
        if let trendingMovies = await loader.getTrendingMovies() {
            await MainActor.run {
                self.trendingMovies = trendingMovies
            }
        }
    }
    
    func fetchTrendingTvs() async {
        if let trendingTvs = await loader.getTrendingTvs() {
            await MainActor.run {
                self.trendingTvs = trendingTvs
            }
        }
    }
    
    func fetchUpcomingMovies() async {
        if let upcomingMovies = await loader.getUpcomingMovies() {
            await MainActor.run {
                self.upcomingMovies = upcomingMovies
            }
        }
    }
    
    func fetchPopularMovies() async {
        if let popularMovies = await loader.getPopularMovies() {
            await MainActor.run {
                self.popularMovies = popularMovies
            }
        }
    }
    
    func fetchTopRatedMovies() async {
        if let topRatedMovies = await loader.getTopRatedMovies() {
            await MainActor.run {
                self.topRatedMovies = topRatedMovies
            }
        }
    }
    
    func fetchTopRatedTvs() async {
        if let topRatedTvs = await loader.getTopRatedTvs() {
            await MainActor.run {
                self.topRatedTvs = topRatedTvs
            }
        }
    }
    
    func fetchSearchedMovies(searchText: String) async {
        if let searchedMovies = await loader.searchMovies(searchText: searchText) {
            await MainActor.run {
                self.searchedMovies = searchedMovies
            }
        }
    }
    
    func fetchSearchedTvs(searchText: String) async {
        if let searchedTvs = await loader.searchTvs(searchText: searchText) {
            await MainActor.run {
                self.searchedTvs = searchedTvs
            }
        }
    }
    
    func fetchTrailer(searchText: String) async {
        if let videoElement = await loader.getTrailer(searchText: searchText) {
            await MainActor.run {
                self.selectedShowVideoElement = videoElement
            }
        }
    }
    
    func downloadMovie(movie: Movie) {
        downloadedMovies.insert(movie, at: 0)
        save()
    }
    
    func downloadTv(tv: Tv) {
        downloadedTVs.insert(tv, at: 0)
        save()
    }
    
    func removeMovieFromList(at index: IndexSet) {
        downloadedMovies.remove(atOffsets: index)
        save()
    }
    
    func removeTvFromList(at index: IndexSet) {
        downloadedTVs.remove(atOffsets: index)
        save()
    }
    
    func removeMovie(at index: Int) {
        downloadedMovies.remove(at: index)
        save()
    }
    
    func removeTv(at index: Int) {
        downloadedTVs.remove(at: index)
        save()
    }
    
    
    
    private func save() {
        do {
            let moviesData = try JSONEncoder().encode(downloadedMovies)
            let TvsData = try JSONEncoder().encode(downloadedTVs)
            
            try moviesData.write(to: savedMoviesPath, options: [.atomic, .completeFileProtection])
            try TvsData.write(to: savedTVsPath, options: [.atomic, .completeFileProtection])
            
        } catch {
            print("Failed saving data \(error.localizedDescription)")
        }
    }
}
