//
//  WebService.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 25/12/2023.
//

import UIKit

struct WebService {
    private let baseURL = "http://localhost:3000"
    private let session = URLSession.shared
    private let imageCache = NSCache<NSString, UIImage>()
    var authManager = AuthenticationManager.instance

    func downloadImage(from imageURL: String) async -> Result<UIImage, RequestError> {
        do {
            guard let url = URL(string: imageURL) else {
                return .failure(.invalidUrl)
            }

            if let cachedImage = imageCache.object(forKey: imageURL as NSString) {
                return .success(cachedImage)
            }

            let (data, response) = try await session.data(from: url)

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
