//
//  MoviesAPI.swift
//  Netflix
//
//  Created by Azoz Salah on 02/12/2023.
//

import Foundation

class MoviesAPI {
    static var shared = MoviesAPI()
    
    func loadMovies(list: MoviesList, completion: @escaping (Result<[Movie], Error>) -> ()) async {
        guard let url = URL(string: list.url) else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            completion(handleMoviesResponse(data: data, response: response))
        } catch {
            print("Failed download data \(error.localizedDescription)")
            return
        }
    }
    
    func searchMovies(searchText: String, completion: @escaping (Result<[Movie], Error>) -> ()) async {
        guard let finalText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return completion(.failure(URLError(.badURL))) }
        
        guard let url = URL(string: Constants.searchMoviesURL + finalText) else { return completion(.failure(URLError(.badURL))) }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            completion(handleMoviesResponse(data: data, response: response))
        } catch {
            print("Failed download data \(error.localizedDescription)")
            return
        }
    }
    
    func handleMoviesResponse(data: Data?, response: URLResponse?) -> Result<[Movie], Error> {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else { return .failure(URLError(.badURL)) }
        
        do {
            let results = try JSONDecoder().decode(MoviesResponse.self, from: data)
            let movies = results.results
            return .success(movies)
        } catch {
            print("Failed decoding data \(error.localizedDescription)")
            return .failure(URLError(.badServerResponse))
        }
                
    }
}
