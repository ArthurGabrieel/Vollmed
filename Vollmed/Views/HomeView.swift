//
//  HomeView.swift
//  Vollmed
//
//  Created by Arthur Gabriel on 25/12/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var specialists: [Specialist] = []
    @State private var isLoading = true
    var authManager = AuthenticationManager.instance
    
    let service = WebService()
    
    func getSpecialists() async {
        let result = await service.getAllSpecialists()
        
        switch result {
        case .success(let specialists):
            self.specialists = specialists
        case .failure(let error):
            print(error.localizedDescription)
        }
        isLoading = false
    }
    
    func logout() async {
        let result = await service.logoutPatient()
        
        switch result {
        case .success(_):
            authManager.removeToken()
            authManager.removePatientID()
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    Image(.logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(.vertical, 32)
                    Text("Boas-vindas!")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color(.lightBlue))
                    Text("Veja abaixo os especialistas da Vollmed disponíveis e marque já a sua consulta!")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.accent)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                    ForEach(specialists) { specialist in
                        SpecialistCardView(specialist: specialist)
                            .padding(.bottom, 8)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
        .task {
            await getSpecialists()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task {
                        await logout()
                    }
                }, label: {
                    HStack(spacing: 2) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Logout")
                    }
                })
            }
        }
    }
}

#Preview {
    HomeView()
}
