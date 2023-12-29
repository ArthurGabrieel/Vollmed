//
//  DownloadImageService.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import UIKit

protocol DownloadImageServiceable {
    func downloadImage(from imageURL: String) async -> Result<UIImage?, RequestError>
}

struct DownloadImageService: HTTPClient, DownloadImageServiceable {
    private let imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(from imageURL: String) async -> Result<UIImage?, RequestError> {
        do {
            guard let url = URL(string: imageURL) else {
                return .failure(.invalidUrl)
            }
            
            if let cachedImage = imageCache.object(forKey: imageURL as NSString) {
                return .success(cachedImage)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            if response.statusCode == 200 {
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: imageURL as NSString)
                    return .success(image)
                }
            }
            return .failure(.badRequest("Error dowloading image"))
        } catch {
            return .failure(.badRequest(error.localizedDescription))
        }
    }
}
