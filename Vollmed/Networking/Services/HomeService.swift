//
//  HomeService.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

protocol HomeServiceable {
    func getAllSpecialists() async -> Result<[Specialist]?, RequestError>
}

struct HomeService: HTTPClient, HomeServiceable {
    func getAllSpecialists() async -> Result<[Specialist]?, RequestError> {
        return await sendRequest(endpoint: HomeEndpoint.getAllSpecialists, responseModel: [Specialist].self)
    }
}
