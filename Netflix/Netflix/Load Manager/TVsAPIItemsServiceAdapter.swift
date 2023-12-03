//
//  TVsAPIItemsServiceAdapter.swift
//  Netflix
//
//  Created by Azoz Salah on 02/12/2023.
//

import Foundation

struct TVsAPIItemsServiceAdapter: ItemsService {
    let api: TVsAPI
    let list: TVsList?
    
    /// List loading init
    init(api: TVsAPI, list: TVsList?) {
        self.api = api
        self.list = list
    }
    
    /// Search init
    init(api: TVsAPI) {
        self.api = api
        self.list = nil
    }
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> ()) async {
        guard let list = list else { return }
        await api.loadTvs(list: list) { result in
            completion( result.map({ tvs in
                return tvs.map { tv in
                    tv.toItemViewModel()
                }
            }))
        }
    }
    
    func searchItems(searchText: String, completion: @escaping (Result<[ItemViewModel], Error>) -> ()) async {
        await api.searchTVs(searchText: searchText) { result in
            completion(result.map({ tvs in
                return tvs.map { tv in
                    tv.toItemViewModel()
                }
            }))
        }
    }
    
}
