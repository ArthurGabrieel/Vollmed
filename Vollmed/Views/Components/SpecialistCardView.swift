//
//  SpecialistCardView.swift
//  Vollmed
//
//  Created by Arthur Gabriel on 25/12/2023.
//

import SwiftUI

struct SpecialistCardView: View {
    @State private var specialistImage: UIImage?
    let service = WebService()
    
    var specialist: Specialist
    var appointment: Appointment?
    
    func dowloadImage(from imageURL: String) async {
        let result = await service.downloadImage(from: imageURL)
        
        switch result {
        case .success(let image):
            self.specialistImage = image
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 16.0) {
                Image(uiImage: specialistImage ?? .doctor)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 8.0) {
                    Text(specialist.name)
                        .font(.title3)
                        .bold()
                    Text(specialist.specialty)
                    if let appointment {
                        Text(appointment.date.convertDateStringToReadableDate())
                            .bold()
                    }
                }
            }
            if let appointment {
                HStack {
                    NavigationLink {
                        ScheduleAppointmentView(specialistID: specialist.id, isRescheduleView: true, appointmentID: appointment.id)
                    } label: {
                        ButtonView(text: "Remarcar")
                    }
                    
                    NavigationLink {
                        CancelAppointmentView(appointmentID: appointment.id)
                    } label: {
                        ButtonView(text: "Cancelar", buttonType: .cancel)
                    }
                }
            } else {
                NavigationLink {
                    ScheduleAppointmentView(specialistID: specialist.id)
                } label: {
                    ButtonView(text: "Agendar consulta")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.lightBlue).opacity(0.15))
        .cornerRadius(16.0)
        .task {
            await dowloadImage(from: specialist.imageUrl)
        }
    }
}

#Preview {
    SpecialistCardView(specialist:
                        Specialist(id: "c84k5kf",
                                   name: "Dr. Carlos Alberto",
                                   crm: "123456",
                                   imageUrl: "https://images.unsplash.com/photo-1637059824899-a441006a6875?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=752&q=80",
                                   specialty: "Neurologia",
                                   email: "carlos.alberto@example.com",
                                   phoneNumber: "(11) 99999-9999"
                                  ))
}
