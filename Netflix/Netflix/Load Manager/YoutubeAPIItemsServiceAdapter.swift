//
//  YoutubeAPIItemsServiceAdapter.swift
//  Netflix
//
//  Created by Azoz Salah on 05/12/2023.
//

import Foundation


struct YoutubeAPIItemsServiceAdapter: ItemsService {
    let api: YoutubeAPI
    let searchText: String
    
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> ()) async {
        await api.getTrailer(searchText: searchText) { result in
            completion(result.map { video in
                return [ItemViewModel(title: video.id.videoId)]
            })
        }
    }
}
