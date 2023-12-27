//
//  Login.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 27/12/23.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password = "senha"
    }
}

struct LoginResponse: Codable, Identifiable {
    let id: String
    let auth: Bool
    let token: String
}
