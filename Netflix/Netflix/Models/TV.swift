//
//  TV.swift
//  Netflix
//
//  Created by Azoz Salah on 02/02/2023.
//

import Foundation

struct TrendingTvsResponse: Codable {
    let results: [Tv]
}

struct Tv: Identifiable, Codable {
    let id: Int
    let media_type: String?
    let name: String?
    let origin_country: [String?]
    let original_language: String
    let original_name: String?
    let overview: String?
    let poster_path: String
    let vote_average: Double
    let vote_count: Int
    
    var posterURL: URL? {
        return URL(string: "\(Constants.imageBaseURL)\(poster_path)")
    }
    
    var wrappedTitle: String {
        if let name = name {
            return name
        } else {
            return "Unknown TV title"
        }
    }
    
    var wrappedOverview: String {
        if let overview = overview {
            return overview
        } else {
            return "Unknown Story"
        }
    }
    
    var wrappedOriginCountry: String {
        if let country = origin_country.first {
            return country ?? "Unknown country"
        } else {
            return "Unknown country"
        }
    }
    
    static func ==(lhs: Tv, rhs: Tv) -> Bool {
        lhs.id == rhs.id
    }
    
}
