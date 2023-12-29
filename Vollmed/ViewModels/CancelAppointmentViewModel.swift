//
//  MyAppointmentsViewModel.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

struct CancelAppointmentViewModel {
    let service: AppointmentServiceable
    let authManager = AuthenticationManager.instance

    init(service: AppointmentServiceable) {
        self.service = service
    }

    func cancelAppointment(id: String, reason: String) async -> Bool {
        let result = await service.cancelAppointment(id: id,
                                                     reason: reason)

        switch result {
        case .success:
            return true
        case let .failure(error):
            print(error.customMessage)
            return false
        }
    }
}
