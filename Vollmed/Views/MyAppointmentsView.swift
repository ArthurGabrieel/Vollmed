//
//  MyAppointmentsView.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 25/12/23.
//

import SwiftUI

struct MyAppointmentsView: View {
    @State private var appointments: [Appointment] = []
    let viewModel = MyAppointmentsViewModel(service: AppointmentService())

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
                        SpecialistCardView(specialist: appointment.specialist, 
                                           appointment: appointment)
                    }
                }
            }
        }
        .navigationTitle("Minhas consultas")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .task {
            if let appointments = await viewModel.getAppointmentsFromPatient() {
                self.appointments = appointments
            }
        }
    }
}

#Preview {
    MyAppointmentsView()
}
