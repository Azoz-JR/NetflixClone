//
//  MoviesList.swift
//  Netflix
//
//  Created by Azoz Salah on 02/12/2023.
//

import Foundation

enum MoviesList {
    case trending
    case upcoming
    case popualr
    case topRated
    
    var url: String {
        switch self {
        case .trending:
            return Constants.trendingMoviesURL
        case .upcoming:
            return Constants.upcomingMoviesURL
        case .popualr:
            return Constants.popularMoviesURL
        case .topRated:
            return Constants.topRatedMoviesURL
        }
    }
}
