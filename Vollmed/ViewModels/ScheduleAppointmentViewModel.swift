//
//  ScheduleAppointmentViewModel.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

struct ScheduleAppointmentViewModel {
    let authManager = AuthenticationManager.instance
    let service: AppointmentServiceable

    init(service: AppointmentServiceable) {
        self.service = service
    }

    func scheduleAppointment(_ specialistID: String, date: Date) async -> Bool {
        guard let patientID = authManager.patientID else {
            print("error to get patient id")
            return false
        }

        let appointmentRequest = ScheduleAppointmentRequest(specialist: specialistID,
                                                            patient: patientID,
                                                            date: date.convertToString())

        let result = await service.scheduleAppointment(appointmentRequest)

        switch result {
        case .success:
            return true
        case let .failure(error):
            print(error.customMessage)
            return false
        }
    }

    func rescheduleAppointment(id: String, date: Date) async -> Bool {
        let result = await service.rescheduleAppointment(id: id,
                                                         date: date.convertToString())

        switch result {
        case .success:
            return true
        case let .failure(error):
            print(error.customMessage)
            return false
        }
    }
}
