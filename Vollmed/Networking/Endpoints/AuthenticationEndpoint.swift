//
//  AuthenticationEndpoint.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

enum AuthenticationEndpoint {
    case logout
    case login(body: [String: String]?)
    case register(body: [String: String]?)
}

extension AuthenticationEndpoint: Endpoint {
    var path: String {
        switch self {
        case .logout:
            return "/auth/logout"
        case .login:
            return "/auth/login"
        case .register:
            return "/paciente"
        }
    }

    var method: RequestMethod {
        return .post
    }

    var header: [String: String]? {
        switch self {
        case .logout:
            guard let token = AuthenticationManager.instance.token else {
                return nil
            }
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
        default:
            return ["Content-Type": "application/json"]
        }
    }

    var body: [String: String]? {
        switch self {
        case .logout:
            return nil
        case .login(let body):
            return body
        case .register(let body):
            return body
        }
    }
}
