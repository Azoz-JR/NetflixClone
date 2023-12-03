//
//  TVsList.swift
//  Netflix
//
//  Created by Azoz Salah on 02/12/2023.
//

import Foundation

enum TVsList {
    case trending
    case topRated
    
    var url: String {
        switch self {
        case .trending:
            return Constants.trendingTVsURL
        case .topRated:
            return Constants.topRatedTVsURL
        }
    }
}
