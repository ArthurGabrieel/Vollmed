//
//  SignUpView.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 26/12/23.
//

import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var cpf = ""
    @State private var phoneNumber = ""
    @State private var healthPlan = "Amil"
    @State private var password = ""
    @State private var showAlert = false
    @State private var isPatientRegistered = false
    @State private var navigateToSignInView: Bool = false

    let viewModel = AuthenticationViewModel(service: AuthenticationService())

    let healthPlans = [
        "Amil", "Unimed", "Bradesco Saúde", "SulAmérica",
        "Hapvida", "Notredame Intermédica", "São Francisco Saúde",
        "Golden Cross", "Medial Saúde", "América Saúde", "Outro",
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                SignUpHeaderView()
                TextFieldWithTitle(title: "Nome", placeholder: "Insira seu nome completo", text: $name)
                TextFieldWithTitle(title: "Email", placeholder: "Insira seu email", text: $email, keyboardType: .emailAddress)
                TextFieldWithTitle(title: "CPF", placeholder: "Insira seu CPF", text: $cpf, keyboardType: .numberPad)
                TextFieldWithTitle(title: "Telefone", placeholder: "Insira seu telefone", text: $phoneNumber, keyboardType: .numberPad)
                TextFieldWithTitle(title: "Senha", placeholder: "Insira sua senha", text: $password, isPassword: true)
                HealthPlanPickerView(healthPlan: $healthPlan, healthPlans: healthPlans)
                Button(action: {
                    Task {
                        let isRegistered = await viewModel.register(Patient(id: nil, name: name, cpf: cpf,
                                                                            email: email, phoneNumber: phoneNumber,
                                                                            healthPlan: healthPlan, password: password))
                        isPatientRegistered = isRegistered
                        showAlert = true
                    }
                }, label: {
                    ButtonView(text: "Cadastrar")
                })

                NavigationLink {
                    SignInView()
                } label: {
                    Text("Já possui uma conta? Faça o login!")
                        .bold()
                        .foregroundStyle(.accent)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarBackButtonHidden()
            .padding()
            .alert(isPatientRegistered ? "Sucesso" : "Ops! Algo deu errado!", isPresented: $showAlert, presenting: $isPatientRegistered) { _ in
                Button(action: {
                           navigateToSignInView = isPatientRegistered
                       },
                       label: {
                           Text("Ok")
                       })
            } message: { _ in
                Text(isPatientRegistered ?
                    "O paciente foi cadastrado com sucesso" :
                    "Houve um erro ao cadastrar o paciente. Por favor tente novamente.")
            }
        }
        .navigationDestination(isPresented: $navigateToSignInView) {
            SignInView()
        }
    }
}

struct SignUpHeaderView: View {
    var body: some View {
        Image(.logo)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 36, alignment: .center)
            .padding(.vertical)
        Text("Olá, Boas Vindas!")
            .font(.title2)
            .bold()
            .foregroundStyle(.accent)

        Text("Insira seus dados para criar uma conta.")
            .font(.title3)
            .bold()
            .foregroundStyle(.gray)
            .padding(.bottom)
    }
}

struct HealthPlanPickerView: View {
    @Binding var healthPlan: String
    let healthPlans: [String]

    var body: some View {
        Text("Selecione o seu plano de saúde")
            .font(.title3)
            .bold()
            .foregroundStyle(.accent)

        Picker("Plano de saúde", selection: $healthPlan) {
            ForEach(healthPlans, id: \.self) { healthPlan in
                Text(healthPlan)
            }
        }
    }
}

#Preview {
    SignUpView()
}
