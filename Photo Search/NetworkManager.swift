//
//  NetworkManager.swift
//  Photo Search
//
//  Created by Anton Duplin on 25/8/22.
//

import Foundation
let apiKey = "4oluHlsNuEvv563Z3tYH62S4nWsx1qqfBv-Akkm8XmE"
struct NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImages(query: String, with complition: @escaping(SearchResults?)-> Void) {
        let query = query.split(separator: " ").joined(separator: "%20")
        let stringURL = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=\(query)&client_id=\(apiKey)"
        guard let url = URL(string: stringURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            
            do{
                let unsplashPhotos = try JSONDecoder().decode(SearchResults.self, from: data)
                print(unsplashPhotos.results.count)
                DispatchQueue.main.async {
                    complition(unsplashPhotos)
                }
            }
            catch let error {
                print(error)
            }
        }
        .resume()
        
    }
}

class ImageManager {
    static var shared = ImageManager()
    
    private init() {}
    
    func fetchImage(from url: URL, complition: @escaping (Data, URLResponse) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            guard url == response.url else { return }
            
            complition(data, response)
            
        }.resume()
    }
}


