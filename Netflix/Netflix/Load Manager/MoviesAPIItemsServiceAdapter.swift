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
    
    /// List loading init
    init(api: MoviesAPI, list: MoviesList?) {
        self.api = api
        self.list = list
    }
    
    /// Search init
    init(api: MoviesAPI) {
        self.api = api
        self.list = nil
    }

    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> ()) async {
        guard let list = list else { return }
        await api.loadMovies(list: list) { result in
            completion(result.map({ movies in
                return movies.map { movie in
                    movie.toItemViewModel()
                }
            })
            )
        }
    }
    
    func searchItems(searchText: String, completion: @escaping (Result<[ItemViewModel], Error>) -> ()) async {
        await api.searchMovies(searchText: searchText) { result in
            completion(result.map({ movies in
                return movies.map { movie in
                    movie.toItemViewModel()
                }
            }))
        }
    }
        
}
