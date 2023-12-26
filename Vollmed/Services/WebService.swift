//
//  WebService.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 25/12/2023.
//

import UIKit

enum RequestError: Error {
    case urlError
    case invalidResponse
    case badRequest(String)
}


let patientID = "1b171dbe-f405-4f7b-9805-84f8ca0d60eb"

struct WebService {
    private let baseURL = "http://localhost:3000"
    private let session = URLSession.shared
    private let imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(from imageURL: String) async -> Result<UIImage, RequestError> {
        do {
            guard let url = URL(string: imageURL) else {
                return .failure(.urlError)
            }
            
            if let cachedImage = imageCache.object(forKey: imageURL as NSString) {
                return .success(cachedImage)
            }
            
            let (data, response) = try await session.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            if response.statusCode == 200 {
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: imageURL as NSString)
                    return .success(image)
                }
            }
            return .failure(.badRequest("Error dowloading image"))
        } catch {
            return .failure(.badRequest(error.localizedDescription))
        }
    }
    
    func getAllSpecialists() async -> Result<[Specialist], RequestError> {
        do {
            let endpoint = baseURL + "/especialista"
            guard let url = URL(string: endpoint) else {
                return .failure(.urlError)
            }
            
            let (data, response) = try await session.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            if response.statusCode == 200 {
                let specialists = try JSONDecoder().decode([Specialist].self, from: data)
                return .success(specialists)
            }
            return .failure(.badRequest("Unexpected error in getAllSpecialists"))
        } catch {
            return .failure(.badRequest(error.localizedDescription))
        }
    }
    
    func scheduleAppointment(_ appointment: ScheduleAppointmentRequest) async -> Result<ScheduleAppointmentResponse, RequestError> {
        do {
            let endpoint = baseURL + "/consulta"
            guard let url = URL(string: endpoint) else {
                return .failure(.urlError)
            }
            
            let jsonData = try JSONEncoder().encode(appointment)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            if response.statusCode == 200 {
                let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
                return .success(appointmentResponse)
            }
            return .failure(.badRequest("Unexpected error in scheduleAppointment"))
        } catch {
            return .failure(.badRequest(error.localizedDescription))
        }
    }
    
    func rescheduleAppointment(id appointmentID: String, date: String) async -> Result<ScheduleAppointmentResponse, RequestError> {
        do {
            let endpoint = "\(baseURL)/consulta/\(appointmentID)"
            guard let url = URL(string: endpoint) else {
                return .failure(.urlError)
            }
            
            let requestData: [String: String] = ["data": date]
            let jsonData = try  JSONSerialization.data(withJSONObject: requestData)
            
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            if response.statusCode == 200 {
                let appointmentResponse = try JSONDecoder().decode(ScheduleAppointmentResponse.self, from: data)
                return .success(appointmentResponse)
            }
            return .failure(.badRequest("Unexpected error in rescheduleAppointment"))
        } catch {
            return .failure(.badRequest(error.localizedDescription))
        }
    }
    
    func getAllAppointmentsFromPatient(id patientID: String) async -> Result<[Appointment], RequestError> {
        do {
            let endpoint = baseURL + "/paciente/\(patientID)/consultas"
            guard let url = URL(string: endpoint) else {
                return .failure(.urlError)
            }
            
            let (data, response) = try await session.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            if response.statusCode == 200 {
                let appointments = try JSONDecoder().decode([Appointment].self, from: data)
                return .success(appointments)
            }
            return .failure(.badRequest("Unexpected error in getAllSpecialists"))
        } catch {
            return .failure(.badRequest(error.localizedDescription))
        }
    }
    
    func cancelAppointment(id appointmentID: String, reason: String) async -> Result<Bool, RequestError>{
        do {
            let endpoint = baseURL + "/consulta/\(appointmentID)"
            guard let url = URL(string: endpoint) else {
                return .failure(.urlError)
            }
            
            let requestData = ["motivoCancelamento": reason]
            let jsonData = try  JSONSerialization.data(withJSONObject: requestData)
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let (_, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            if response.statusCode == 200 {
                return .success(true)
            }
            return .failure(.badRequest("Error to cancel appointment"))
        } catch {
            return .failure(.badRequest(error.localizedDescription))
        }
    }
}
