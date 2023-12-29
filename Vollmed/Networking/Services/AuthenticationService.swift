//
//  AuthenticationService.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

protocol AuthenticationServiceable {
    func logout() async -> Result<Bool?, RequestError>
    func login(loginRequest: LoginRequest) async -> Result<LoginResponse?, RequestError>
    func registerPatient(_ patient: Patient) async -> Result<Patient?, RequestError>
}

struct AuthenticationService: HTTPClient, AuthenticationServiceable {
    func logout() async -> Result<Bool?, RequestError> {
        return await sendRequest(endpoint: AuthenticationEndpoint.logout, responseModel: nil)
    }

    func login(loginRequest: LoginRequest) async -> Result<LoginResponse?, RequestError> {
        return await sendRequest(endpoint: AuthenticationEndpoint.login(body: loginRequest.toJson()),
                                 responseModel: LoginResponse.self)
    }

    func registerPatient(_ patient: Patient) async -> Result<Patient?, RequestError> {
        return await sendRequest(endpoint: AuthenticationEndpoint.register(body: patient.toJson()),
                                 responseModel: Patient.self)
    }
}
