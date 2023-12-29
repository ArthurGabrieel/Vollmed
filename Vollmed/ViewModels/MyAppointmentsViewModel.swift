//
//  MyAppointmentsViewModel.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

struct MyAppointmentsViewModel {
    let service: AppointmentServiceable
    let authManager = AuthenticationManager.instance

    init(service: AppointmentServiceable) {
        self.service = service
    }

    func getAppointmentsFromPatient() async -> [Appointment]? {
        guard let patientID = authManager.patientID else {
            print("error to get patient id")
            return nil
        }
        let result = await service.getAllAppointmentsFromPatient(id: patientID)

        switch result {
        case let .success(appointments):
            return appointments
        case let .failure(error):
            print(error.customMessage)
            return nil
        }
    }
}
