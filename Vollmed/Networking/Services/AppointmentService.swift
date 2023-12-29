//
//  AppointmentService.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

protocol AppointmentServiceable {
    func getAllAppointmentsFromPatient(id patientID: String) async -> Result<[Appointment]?, RequestError>
    func scheduleAppointment(_ appointment: ScheduleAppointmentRequest) async -> Result<ScheduleAppointmentResponse?, RequestError>
    func rescheduleAppointment(id appointmentID: String, date: String) async -> Result<ScheduleAppointmentResponse?, RequestError>
    func cancelAppointment(id appointmentID: String, reason: String) async -> Result<Bool?, RequestError>
}

struct AppointmentService: HTTPClient, AppointmentServiceable {
    func getAllAppointmentsFromPatient(id patientID: String) async -> Result<[Appointment]?, RequestError> {
        return await sendRequest(endpoint: AppointmentEndpoint.getAppointments(id: patientID),
                                 responseModel: [Appointment].self)
    }

    func scheduleAppointment(_ appointment: ScheduleAppointmentRequest) async -> Result<ScheduleAppointmentResponse?, RequestError> {
        return await sendRequest(endpoint: AppointmentEndpoint.schedule(body: appointment.toJson()),
                                 responseModel: ScheduleAppointmentResponse.self)
    }

    func rescheduleAppointment(id appointmentID: String, date: String) async -> Result<ScheduleAppointmentResponse?, RequestError> {
        return await sendRequest(endpoint: AppointmentEndpoint.reschedule(id: appointmentID, body: ["data": date]),
                                 responseModel: ScheduleAppointmentResponse.self)
    }

    func cancelAppointment(id appointmentID: String, reason: String) async -> Result<Bool?, RequestError> {
        return await sendRequest(endpoint: AppointmentEndpoint.cancel(id: appointmentID,
                                                                      body: ["motivoCancelamento": reason]), responseModel: nil)
    }
}
