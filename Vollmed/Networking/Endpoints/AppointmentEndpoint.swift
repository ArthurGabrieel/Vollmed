//
//  AppointmentEndpoint.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

enum AppointmentEndpoint {
    case getAppointments(id: String)
    case schedule(body: [String: String]?)
    case reschedule(id: String, body: [String: String]?)
    case cancel(id: String, body: [String: String]?)
}

extension AppointmentEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getAppointments(let id):
            return "/paciente/\(id)/consultas"
        case .schedule:
            return "/consulta"
        case .reschedule(let id, _):
            return "/consulta/\(id)"
        case .cancel(let id, _):
            return "/consulta/\(id)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getAppointments:
            return .get
        case .schedule:
            return .post
        case .reschedule:
            return .patch
        case .cancel:
            return .delete
        }
    }

    var header: [String: String]? {
        guard let token = AuthenticationManager.instance.token else {
            return nil
        }
        
        switch self {
        case .getAppointments:
            return ["Authorization": "Bearer \(token)"]
        default:
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
        }
    }

    var body: [String: String]? {
        switch self {
        case .getAppointments:
            return nil
        case .schedule(body: let body):
            return body
        case .reschedule(_, body: let body):
            return body
        case .cancel(_, body: let body):
            return body
        }
    }
}
