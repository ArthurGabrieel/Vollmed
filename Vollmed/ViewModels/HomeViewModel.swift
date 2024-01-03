//
//  HomeViewModel.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

struct HomeViewModel {
    let authManager = AuthenticationManager.instance
    let homeService: HomeServiceable
    let authService: AuthenticationServiceable

    init(homeService: HomeServiceable, authService: AuthenticationServiceable) {
        self.homeService = homeService
        self.authService = authService
    }

    func getSpecialists() async throws -> [Specialist]? {
        let result = await homeService.getAllSpecialists()

        switch result {
        case let .success(response):
            return response
        case let .failure(error):
            throw error
        }
    }

    func logout() async {
        let result = await authService.logout()

        switch result {
        case .success:
            authManager.removeToken()
            authManager.removePatientID()
        case let .failure(error):
            print(error.customMessage)
        }
    }
}
