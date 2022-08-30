//
//  imageView.swift
//  Photo Search
//
//  Created by Anton Duplin on 30/8/22.
//

import Foundation
import UIKit

class imageView: UIImageView {

    func fetchImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        // Использовать изображение из кеша, если есть
        if let cachedImage = getChachedImage(from: imageURL) {
            image = cachedImage
            return
        }
        
        // Если изображения нет то мы загрузим его из сети
        ImageManager.shared.fetchImage(from: imageURL) { data, response in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            
            // Сохранить изображение в кэш
            self.seveDataToCache(with: data, and: response)
            
        }
    }
    
    private func seveDataToCache(with data: Data, and response: URLResponse) {
        guard let urlResponse = response.url else { return }
        let request = URLRequest(url: urlResponse)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getChachedImage(from url: URL) -> UIImage? {
        
        let request = URLRequest(url: url)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
}
