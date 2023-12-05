//
//  YoutubeAPI.swift
//  Netflix
//
//  Created by Azoz Salah on 04/12/2023.
//

import Foundation

class YoutubeAPI {
    static var shared = YoutubeAPI()
    
    func handleYoutubeResponse(data: Data?, response: URLResponse?) -> Result<VideoElement, Error> {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else { return .failure(URLError(.badURL)) }
        
        do {
            let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
            if let firstResult = results.items.first {
                return .success(firstResult)
            }
            return .failure(URLError(.badServerResponse))
        } catch {
            print("Failed decoding data \(error.localizedDescription)")
            return .failure(URLError(.badServerResponse))
        }
    }
    
    func getTrailer(searchText: String, completion: @escaping (Result<VideoElement, Error>) -> ()) async {
        guard let finalText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtubeBaseURL)q=\(finalText)&key=\(Constants.youtubeAPIKey)") else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            return completion(handleYoutubeResponse(data: data, response: response))
        } catch {
            print("Failed get movie trailer \(error.localizedDescription)")
            return
        }
    }
}


