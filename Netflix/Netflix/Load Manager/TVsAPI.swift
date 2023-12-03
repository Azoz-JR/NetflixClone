//
//  TVsAPI.swift
//  Netflix
//
//  Created by Azoz Salah on 02/12/2023.
//

import Foundation

class TVsAPI {
    static var shared = TVsAPI()
    
    func loadTvs(list: TVsList, completion: @escaping (Result<[Tv], Error>) -> ()) async {
        guard let url = URL(string: list.url) else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            completion(handleTvsResponse(data: data, response: response))
        } catch {
            print("Failed download data \(error.localizedDescription)")
            return
        }
    }
    
    func searchTVs(searchText: String, completion: @escaping (Result<[Tv], Error>) -> ()) async {
        guard let finalText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return completion(.failure(URLError(.badURL))) }
        
        guard let url = URL(string: Constants.searchTVsURL + finalText) else { return completion(.failure(URLError(.badURL))) }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            completion(handleTvsResponse(data: data, response: response))
        } catch {
            print("Failed download data \(error.localizedDescription)")
            return
        }
    }
    
    func handleTvsResponse(data: Data?, response: URLResponse?) -> Result<[Tv], Error> {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else { return .failure(URLError(.badURL)) }
        
        do {
            let results = try JSONDecoder().decode(TvsResponse.self, from: data)
            let tvs = results.results
            return .success(tvs)
        } catch {
            print("Failed decoding data \(error.localizedDescription)")
            return .failure(URLError(.badServerResponse))
        }
                
    }
}
