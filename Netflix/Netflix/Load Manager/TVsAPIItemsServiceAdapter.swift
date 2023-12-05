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
    let searchText: String?
    
    /// List loading init
    init(api: TVsAPI, list: TVsList?) {
        self.api = api
        self.list = list
        self.searchText = nil
    }
    
    /// Search init
    init(api: TVsAPI, searchText: String?) {
        self.api = api
        self.searchText = searchText
        self.list = nil
    }
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> ()) async {
        if let list = list {
            await api.loadTvs(list: list) { result in
                completion(handleResults(result))
            }
            return
        }
        
        if let searchText = searchText {
            await api.searchTVs(searchText: searchText) { result in
                completion(handleResults(result))
            }
        }
    }
    
    func handleResults(_ result: Result<[Tv], Error>) -> Result<[ItemViewModel], Error> {
        result.map { tvs in
            return tvs.map { tv in
                tv.toItemViewModel()
            }
        }
    }
    
}
