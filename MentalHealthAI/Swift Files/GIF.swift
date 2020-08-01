//
//  GIF.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/1/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import Foundation

public struct GifArray: Decodable {
    var gifs: [Gif]
    enum CodingKeys: String, CodingKey {
        case gifs = "data"
    }
    
}

struct Gif: Decodable {
    var gifSources: GifImages
    enum CodingKeys: String, CodingKey {
        case gifSources = "images"
    }
    func getGIFURL() -> String {
        return gifSources.original.url
    }
    
}

struct GifImages: Decodable {
    var original: original
    enum CodingKeys: String, CodingKey {
        case original = "original"
    }
}
struct original: Decodable {
    var url: String
}
