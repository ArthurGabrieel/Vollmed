//
//  RequestError.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

enum RequestError: Error {
    case invalidUrl
    case invalidResponse
    case invalidToken
    case unauthorized
    case unknown
    case badRequest(String)

    var customMessage: String {
        switch self {
        case .invalidUrl:
            return "invalid url"
        case .invalidResponse:
            return "invalid response"
        case .invalidToken:
            return "invalid token"
        case .unauthorized:
            return "user unauthorized"
        case .unknown:
            return "unknown error"
        case let .badRequest(error):
            return "bad request: \(error.description)"
        }
    }
}
