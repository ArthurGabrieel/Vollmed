//
//  Patient.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 26/12/23.
//

import Foundation

struct Patient: Codable, Identifiable {
    let id: String?
    let name: String
    let cpf: String
    let email: String
    let phoneNumber: String
    let healthPlan: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case id, cpf, email
        case name = "nome"
        case password = "senha"
        case phoneNumber = "telefone"
        case healthPlan = "planoSaude"
    }
}
