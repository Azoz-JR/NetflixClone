//
//  Constants.swift
//  Netflix
//
//  Created by Azoz Salah on 12/02/2023.
//

import Foundation

struct Constants {
    static let APIKey = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    static let youtubeAPIKey = "AIzaSyAqELjyq0-gLwVH3atr9Sp2G14P8PDtWOY"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}


enum TitleType {
    case trendingMovies, trendingTVs, popularMovies, upcomingMovies, topRatedMovies, topRatedTVs
}

enum ShowType: String {
    case movies = "Movies"
    case TVs = "TVs"
}
