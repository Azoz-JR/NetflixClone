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
