//
//  NetflixViewModel.swift
//  Netflix
//
//  Created by Azoz Salah on 12/02/2023.
//

import Foundation

class NetflixViewModel: ObservableObject {
    
    var service: ItemsService?
    let loader = APICaller()
    
    @Published private(set) var trendingMovies: [ItemViewModel] = []
    @Published private(set) var trendingTvs: [ItemViewModel] = []
    @Published private(set) var upcomingMovies: [ItemViewModel] = []
    @Published private(set) var popularMovies: [ItemViewModel] = []
    @Published private(set) var topRatedMovies: [ItemViewModel] = []
    @Published private(set) var topRatedTvs: [ItemViewModel] = []
    @Published private(set) var searchedShows: [ItemViewModel] = []
    @Published private(set) var selectedShowVideoElement: VideoElement = VideoElement.example
    @Published private(set) var downloadedMovies: [ItemViewModel] = []
    @Published private(set) var downloadedTVs: [ItemViewModel] = []
    
    private let savedMoviesPath = getDocumentsDirectory().appending(path: "Movies")
    private let savedTVsPath = getDocumentsDirectory().appending(path: "TVs")
    
    init() {
        downloadedMovies = fetchSavedData(type: .movies)
        downloadedTVs = fetchSavedData(type: .TVs)
    }
    
    func fetchTrailer(searchText: String) async {
        if let videoElement = await loader.getTrailer(searchText: searchText) {
            await MainActor.run {
                self.selectedShowVideoElement = videoElement
            }
        }
    }
    
    func downloadShow(item: ItemViewModel) {
        if item.type == .movies {
            downloadMovie(movie: item)
        } else {
            downloadTv(tv: item)
        }
    }
    
    func isShowDownloaded(item: ItemViewModel) -> Bool {
        if item.type == .movies {
            return downloadedMovies.contains { $0 == item }
        } else {
            return downloadedTVs.contains { $0 == item }
        }
    }
    
    func deleteShow(item: ItemViewModel) {
        if item.type == .movies {
            if let index = downloadedMovies.firstIndex(where: { $0 == item }) {
                removeMovie(at: index)
            }
        } else {
            if let index = downloadedTVs.firstIndex(where: { $0 == item }) {
                removeTv(at: index)
            }

        }
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
    
    private func fetchSavedData(type: ShowType) -> [ItemViewModel] {
        do {
            let data = try Data(contentsOf: type == .movies ? savedMoviesPath : savedTVsPath)
            
            let decodedMovies = try JSONDecoder().decode([ItemViewModel].self, from: data)
            return decodedMovies
        } catch {
            print("Failed loading data \(error.localizedDescription)")
            return []
        }
    }
    
}

// MARK: All Movies methods
extension NetflixViewModel {
    
    func loadMovies(list: MoviesList, completion: @escaping ([ItemViewModel]) -> ()) async {
        service = MoviesAPIItemsServiceAdapter(api: MoviesAPI.shared, list: list)
        await service?.loadItems { result in
            switch result {
            case .success(let movies):
                completion(movies)
            case .failure(let error):
                print("Error downloading movies: \(error.localizedDescription)")
            }
        }
    }
    
    func searchMovies(searchText: String, completion: @escaping ([ItemViewModel]) -> ()) async {
        service = MoviesAPIItemsServiceAdapter(api: MoviesAPI.shared)
        await service?.searchItems(searchText: searchText) { result in
            switch result {
            case .success(let movies):
                completion(movies)
            case .failure(let error):
                print("Error downloading movies: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchTrendingMovies() async {
        await loadMovies(list: .trending) { items in
            Task {
                await MainActor.run { [weak self] in
                    self?.trendingMovies = items
                }
            }
        }
    }
    
    func fetchUpcomingMovies() async {
        await loadMovies(list: .upcoming) { items in
            Task {
                await MainActor.run { [weak self] in
                    self?.upcomingMovies = items
                }
            }
        }
    }

    func fetchPopularMovies() async {
        await loadMovies(list: .popualr) { items in
            Task {
                await MainActor.run { [weak self] in
                    self?.popularMovies = items
                }
            }
        }
    }
    
    func fetchTopRatedMovies() async {
        await loadMovies(list: .topRated) { items in
            Task {
                await MainActor.run { [weak self] in
                    self?.topRatedMovies = items
                }
            }
        }
    }
    
    func fetchSearchedMovies(searchText: String) async {
        await searchMovies(searchText: searchText) { items in
            Task {
                await MainActor.run { [weak self] in
                    self?.searchedShows = items
                }
            }
        }
    }
    
    private func downloadMovie(movie: ItemViewModel) {
        downloadedMovies.insert(movie, at: 0)
        save()
    }
    
    func removeMovieFromList(at index: IndexSet) {
        downloadedMovies.remove(atOffsets: index)
        save()
    }
    
    private func removeMovie(at index: Int) {
        downloadedMovies.remove(at: index)
        save()
    }
}

// MARK: All Tvs methods
extension NetflixViewModel {
    func loadTvs(list: TVsList, completion: @escaping ([ItemViewModel]) -> ()) async {
        service = TVsAPIItemsServiceAdapter(api: TVsAPI.shared, list: list)
        
        await service?.loadItems { result in
            switch result {
            case .success(let tvs):
                completion(tvs)
            case .failure(let error):
                print("Error downloading movies: \(error.localizedDescription)")
            }
        }
    }
    
    func searchTvs(searchText: String, completion: @escaping ([ItemViewModel]) -> ()) async {
        service = TVsAPIItemsServiceAdapter(api: TVsAPI.shared)
        
        await service?.searchItems(searchText: searchText) { result in
            switch result {
            case .success(let tvs):
                completion(tvs)
            case .failure(let error):
                print("Error downloading movies: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchTrendingTvs() async {
        await loadTvs(list: .trending) { items in
            Task {
                await MainActor.run { [weak self] in
                    self?.trendingTvs = items
                }
            }
        }
    }
    
    func fetchTopRatedTvs() async {
        await loadTvs(list: .topRated) { items in
            Task {
                await MainActor.run { [weak self] in
                    self?.topRatedTvs = items
                }
            }
        }
    }
    
    func fetchSearchedTvs(searchText: String) async {
        await searchTvs(searchText: searchText) { items in
            Task {
                await MainActor.run { [weak self] in
                    self?.searchedShows = items
                }
            }
        }
    }
    
    private func downloadTv(tv: ItemViewModel) {
        downloadedTVs.insert(tv, at: 0)
        save()
    }
    
    func removeTvFromList(at index: IndexSet) {
        downloadedTVs.remove(atOffsets: index)
        save()
    }
    
    private func removeTv(at index: Int) {
        downloadedTVs.remove(at: index)
        save()
    }
}
