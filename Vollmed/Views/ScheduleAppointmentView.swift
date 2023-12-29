//
//  ScheduleAppointmentView.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 25/12/23.
//

import SwiftUI

struct ScheduleAppointmentView: View {
    @State private var selectedDate = Date()
    @State private var showAlert = false
    @State private var isAppointmentScheduled = false
    @Environment(\.presentationMode) var presentationMode
    var authManager = AuthenticationManager.instance

    let viewModel = ScheduleAppointmentViewModel(service: AppointmentService())
    let specialistID: String
    let isRescheduleView: Bool
    let appointmentID: String?

    init(specialistID: String, isRescheduleView: Bool = false, appointmentID: String? = nil) {
        self.specialistID = specialistID
        self.isRescheduleView = isRescheduleView
        self.appointmentID = appointmentID
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("Selecione a data e o horário da consulta")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
                .padding(.top)
            DatePicker("Escolha a data da consulta", selection: $selectedDate, in: Date()...)
                .datePickerStyle(.graphical)
            Spacer()
            Button(action: {
                Task {
                    if isRescheduleView {
                        isAppointmentScheduled = await viewModel.rescheduleAppointment(id: appointmentID!, date: selectedDate)
                    } else {
                        isAppointmentScheduled = await viewModel.scheduleAppointment(specialistID, date: selectedDate)
                    }
                    showAlert = true
                }
            }, label: {
                ButtonView(text: isRescheduleView ? "Reagendar Consulta" : "Agendar consulta")
            })
            Spacer()
        }
        .padding()
        .navigationTitle(isRescheduleView ? "Reagendar Consulta" : "Agendar consulta")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButtonView())
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 30
        }
        .alert(isAppointmentScheduled ? "Sucesso" : "Ops, algo deu errado!",
               isPresented: $showAlert,
               presenting: isAppointmentScheduled)
        { _ in
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("OK")
            })
        } message: { isScheduled in
            Text(isScheduled ?
                "A consulta foi \(isRescheduleView ? "reagendada" : "agendada") com sucesso!" :
                "Houve um erro ao \(isRescheduleView ? "reagendadar" : "agendadar") sua consulta. Por favor tente novamente ou entre em contato via telefone.")
        }
    }
}

#Preview {
    ScheduleAppointmentView(specialistID: "74243a72-e231-408d-8c4e-d8eaf4bee5ad", isRescheduleView: true)
}
