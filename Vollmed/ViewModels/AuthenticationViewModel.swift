//
//  AuthenticationViewModel.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

struct AuthenticationViewModel {
    let authManager = AuthenticationManager.instance
    let service: AuthenticationServiceable
    
    init(service: AuthenticationService) {
        self.service = service
    }
    
    func login(_ userData: LoginRequest) async -> Bool {
        let result = await service.login(loginRequest: userData)
        
        switch result {
        case let .success(response):
            if let response {
                authManager.saveToken(token: response.token)
                authManager.savePatientID(id: response.id)
            }
            return true
        case let .failure(error):
            print(error.customMessage)
            return false
        }
    }
    
    func register(_ patient: Patient) async -> Bool {
        let result = await service.registerPatient(patient)
        
        switch result {
        case .success:
            return true
        case let .failure(error):
            print(error.customMessage)
            return false
        }
    }
}
