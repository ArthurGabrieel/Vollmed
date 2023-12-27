//
//  MyAppointmentsView.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 25/12/23.
//

import SwiftUI

struct MyAppointmentsView: View {
    @State private var appointments: [Appointment] = []
    let service = WebService()
    var authManager = AuthenticationManager.instance
    
    func getAllAppointments() async {
        guard let patientID = authManager.patientID else {
            print("error to get patient id")
            return
        }
        
        let result = await service.getAllAppointmentsFromPatient(id: patientID)
        
        switch result {
        case .success(let appointments):
            self.appointments = appointments
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            if appointments.isEmpty {
                Text("Não há nenhuma consulta agendada no momento!")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.cancel)
                    .multilineTextAlignment(.center)
            } else {
                ScrollView(showsIndicators: false) {
                    ForEach(appointments) { appointment in
                        SpecialistCardView(specialist: appointment.specialist, appointment: appointment)
                    }
                }
            }
        }
        .navigationTitle("Minhas consultas")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .task {
            await getAllAppointments()
        }
    }
}

#Preview {
    MyAppointmentsView()
}
