//
//  GifNetwork.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/1/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import Foundation
class GifNetwork {
    let apiKey = "HK1SmLJILVKrNzJYxeiKMMwcpq9sCGK4"
    func fetchGIFs(searchTerm: String, completion: @escaping (_ response: GifArray?) -> Void) {
        let url = URL(string: "https://api.giphy.com/v1/gifs/search?api_key=\(apiKey)&q=\(searchTerm)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Error fetching from Giphy: ", err.localizedDescription)
            }
            do {
                DispatchQueue.main.async {
                    let object = try! JSONDecoder().decode(GifArray.self, from: data!)
                    completion(object)
                }
            }
            print("Giphy Data: ", data as Any)
        }.resume()
    }
    func urlBuilder(searchTerm: String) -> URL {
        let apikey = apiKey
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.giphy.com"
        components.path = "/v1/gifs/search"
        components.queryItems = [URLQueryItem(name: "api_key", value: apikey), URLQueryItem(name: "q", value: searchTerm), URLQueryItem(name: "limit", value: "1")]
        return components.url!
        
    }
    
    
}
