//
//  HTTPClient.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Codable>(endpoint: Endpoint, responseModel: T.Type?) async -> Result<T?, RequestError>
}

extension HTTPClient {
    func sendRequest<T: Codable>(endpoint: Endpoint, responseModel: T.Type?) async -> Result<T?, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.port = 3000
        
        guard let url = urlComponents.url else {
            return .failure(.invalidUrl)
        }
        
//        let urlApiary = "https://private-fae55-vollmedapierrors.apiary-mock.com/specialists"
//
//        guard let url = URL(string: urlApiary) else {
//            return .failure(.invalidUrl)
//        }
    
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            switch response.statusCode {
            case 200 ..< 300:
                guard let responseModel else {
                    return .success(nil)
                }
                
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.invalidResponse)
                }
                
                return .success(decodedResponse)
            case 400:
                let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                return .failure(.custom(error: errorResponse))
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unknown)
            }
        } catch {
            return .failure(.badRequest(error.localizedDescription))
        }
    }
}
