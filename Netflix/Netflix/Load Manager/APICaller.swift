//
//  APICaller.swift
//  Netflix
//
//  Created by Azoz Salah on 02/02/2023.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

class APICaller {
    
    func handleMoviesResponse(data: Data?, response: URLResponse?) -> [Movie]? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else { return nil }
        
        do {
            let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
            return results.results
        } catch {
            print("Failed decoding data \(error.localizedDescription)")
            return nil
        }
                
    }
    
    func handleTvsResponse(data: Data?, response: URLResponse?) -> [Tv]? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else { return nil }
        
        do {
            let results = try JSONDecoder().decode(TrendingTvsResponse.self, from: data)
            return results.results
        } catch {
            print("Failed decoding data \(error.localizedDescription)")
            return nil
        }
    }
    
    func handleYoutubeResponse(data: Data?, response: URLResponse?) -> VideoElement? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else { return nil }
        
        do {
            let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
            return results.items.first
        } catch {
            print("Failed decoding data \(error.localizedDescription)")
            return nil
        }
    }
    
    func getTrendingMovies() async -> [Movie]?  {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.APIKey)") else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            return handleMoviesResponse(data: data, response: response)
        } catch {
            print("Failed download data \(error.localizedDescription)")
            return nil
        }
    }
    
    func getTrendingTvs() async -> [Tv]? {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.APIKey)") else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            return handleTvsResponse(data: data, response: response)
        } catch {
            print("Failed download data \(error.localizedDescription)")
            return nil
        }
    }
    
    func getUpcomingMovies() async -> [Movie]? {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.APIKey)&language=en-US&page=1") else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            return handleMoviesResponse(data: data, response: response)
        } catch {
            print("Failed download data \(error.localizedDescription)")
            return nil
        }
    }
    
    func getPopularMovies() async -> [Movie]? {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.APIKey)&language=en-US&page=1") else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            return handleMoviesResponse(data: data, response: response)
        } catch {
            print("Failed downloading data \(error.localizedDescription)")
            return nil
        }
    }
    
    func getTopRatedMovies() async -> [Movie]? {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.APIKey)&language=en-US&page=1") else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            return handleMoviesResponse(data: data, response: response)
        } catch {
            print("Failed downloading data \(error.localizedDescription)")
            return nil
        }
    }
    
    func getTopRatedTvs() async -> [Tv]? {
        guard let url = URL(string: "\(Constants.baseURL)/3/tv/top_rated?api_key=\(Constants.APIKey)&language=en-US&page=1") else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            return handleTvsResponse(data: data, response: response)
        } catch {
            print("Failed download data \(error.localizedDescription)")
            return nil
        }
    }
    
    func searchMovies(searchText: String) async -> [Movie]? {
        guard let finalText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.APIKey)&query=\(finalText)") else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            return handleMoviesResponse(data: data, response: response)
        } catch {
            print("Failed download data \(error.localizedDescription)")
            return nil
        }
    }
    
    func searchTvs(searchText: String) async -> [Tv]? {
        guard let finalText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/tv?api_key=\(Constants.APIKey)&query=\(finalText)") else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            return handleTvsResponse(data: data, response: response)
        } catch {
            print("Failed download data \(error.localizedDescription)")
            return nil
        }
    }
    
    func getTrailer(searchText: String) async -> VideoElement? {
        guard let finalText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        guard let url = URL(string: "\(Constants.youtubeBaseURL)q=\(finalText)&key=\(Constants.youtubeAPIKey)") else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            return handleYoutubeResponse(data: data, response: response)
        } catch {
            print("Failed get movie trailer \(error.localizedDescription)")
            return nil
        }
    }
    
}

