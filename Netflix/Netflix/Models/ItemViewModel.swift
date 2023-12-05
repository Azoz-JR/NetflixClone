//
//  ItemViewModel.swift
//  Netflix
//
//  Created by Azoz Salah on 02/12/2023.
//

import Foundation


struct ItemViewModel: Identifiable, Equatable, Codable {
    var id: Int
    let type: ShowType
    let title: String
    let overview: String
    let posterURL: URL?
    let originCountry: String
    
    //Movies init
    init(id: Int, title: String, overview: String, posterURL: URL?) {
        self.id = id
        self.type = .movies
        self.title = title
        self.overview = overview
        self.posterURL = posterURL
        self.originCountry = "Unknown"
    }
    
    //Tv init
    init(id: Int, title: String, overview: String, posterURL: URL?, originCountry: String) {
        self.id = id
        self.type = .TVs
        self.title = title
        self.overview = overview
        self.posterURL = posterURL
        self.originCountry = originCountry
    }
    
    //Video init
    init(title: String) {
        self.id = 0
        self.title = title
        self.type = .movies
        self.overview = ""
        self.posterURL = nil
        self.originCountry = ""
    }
    
    static func ==(lhs: ItemViewModel, rhs: ItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    static let example = ItemViewModel(id: 1, title: "Title", overview: "Overview", posterURL: nil)
}
