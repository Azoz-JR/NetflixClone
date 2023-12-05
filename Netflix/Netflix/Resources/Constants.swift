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
    static let trendingMoviesURL = "\(baseURL)/3/trending/movie/day?api_key=\(APIKey)"
    static let upcomingMoviesURL = "\(baseURL)/3/movie/upcoming?api_key=\(APIKey)&language=en-US&page=1"
    static let popularMoviesURL = "\(baseURL)/3/movie/popular?api_key=\(APIKey)&language=en-US&page=1"
    static let topRatedMoviesURL = "\(baseURL)/3/movie/top_rated?api_key=\(APIKey)&language=en-US&page=1"
    static let trendingTVsURL = "\(baseURL)/3/trending/tv/day?api_key=\(APIKey)"
    static let topRatedTVsURL = "\(baseURL)/3/tv/top_rated?api_key=\(APIKey)&language=en-US&page=1"
    static let searchMoviesURL = "\(baseURL)/3/search/movie?api_key=\(APIKey)&query="
    static let searchTVsURL = "\(baseURL)/3/search/tv?api_key=\(APIKey)&query="
    static let youtubeVideoURL = "https://www.youtube.com/embed/"
}

enum ShowType: String, Codable {
    case movies = "Movies"
    case TVs = "TVs"
}
