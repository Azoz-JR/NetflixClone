//
//  YoutubeSearchResponse.swift
//  Netflix
//
//  Created by Azoz Salah on 06/02/2023.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
    
    static let example = VideoElement(id: IdVideoElement(kind: "example", videoId: "example"))
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
