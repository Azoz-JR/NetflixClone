//
//  ItemsService.swift
//  Netflix
//
//  Created by Azoz Salah on 03/12/2023.
//

import Foundation

protocol ItemsService {
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> ()) async
}


