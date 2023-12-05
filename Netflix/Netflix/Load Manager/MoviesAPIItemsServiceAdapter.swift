//
//  MoviesAPIItemsServiceAdapter.swift
//  Netflix
//
//  Created by Azoz Salah on 02/12/2023.
//

import Foundation

struct MoviesAPIItemsServiceAdapter: ItemsService {
    let api: MoviesAPI
    let list: MoviesList?
    let searchText: String?
    
    /// List loading init
    init(api: MoviesAPI, list: MoviesList?) {
        self.api = api
        self.list = list
        self.searchText = nil
    }
    
    /// Search init
    init(api: MoviesAPI, searchText: String?) {
        self.api = api
        self.searchText = searchText
        self.list = nil
    }

    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> ()) async {
        if let list = list {
            await api.loadMovies(list: list) { result in
                completion(handleResults(result))
            }
            return
        }
        
        if let searchText = self.searchText {
            await api.searchMovies(searchText: searchText) { result in
                completion(handleResults(result))
            }
        }
    }
    
    func handleResults(_ result: Result<[Movie], Error>) -> Result<[ItemViewModel], Error> {
        result.map { movies in
            return movies.map { movie in
                movie.toItemViewModel()
            }
        }
    }
        
}
