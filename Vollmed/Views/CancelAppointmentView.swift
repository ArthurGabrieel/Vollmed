//
//  CancelAppointmentView.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 26/12/23.
//

import SwiftUI

struct CancelAppointmentView: View {
    let appointmentID: String
    let viewModel = CancelAppointmentViewModel(service: AppointmentService())

    @State private var reasonToCancel = ""
    @State private var showAlert = false
    @State private var isAppointmentCancelled = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Conte-nos o motivo do cancelamento da sua consulta")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
                .padding(.top)
                .multilineTextAlignment(.center)
            TextEditor(text: $reasonToCancel)
                .padding()
                .font(.title3)
                .foregroundStyle(.accent)
                .scrollContentBackground(.hidden)
                .background(Color(.lightBlue).opacity(0.15))
                .clipShape(.rect(cornerRadius: 16))
                .frame(maxHeight: 300)
            Spacer()
            Button(action: {
                Task {
                    isAppointmentCancelled = await viewModel.cancelAppointment(id: appointmentID,
                                                                               reason: reasonToCancel)
                    showAlert = true
                }
            }, label: {
                ButtonView(text: "Cancelar consulta", buttonType: .cancel)
            })
            Spacer()
        }
        .padding()
        .navigationTitle("Cancelar consulta")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButtonView())
        .alert(isAppointmentCancelled ? "Sucesso!" : "Ops, algo deu errado!", isPresented: $showAlert, presenting: isAppointmentCancelled) { _ in
            Button("OK", action: {
                presentationMode.wrappedValue.dismiss()
            })
        } message: { isCancelled in
            if isCancelled {
                Text("A consulta foi cancelada com sucesso.")
            } else {
                Text("Houve um erro ao cancelar sua consulta. Por favor tente novamente ou entre em contato via telefone.")
            }
        }
    }
}

#Preview {
    CancelAppointmentView(appointmentID: "12345")
}
