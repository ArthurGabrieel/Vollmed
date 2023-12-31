//
//  SignInView.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 26/12/23.
//

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var isLoading = false
    let viewModel = AuthenticationViewModel(service: AuthenticationService())

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                SignInHeaderView()
                TextFieldWithTitle(title: "Email", placeholder: "Insira seu email", text: $email, keyboardType: .emailAddress)
                TextFieldWithTitle(title: "Senha", placeholder: "Insira sua senha", text: $password, isPassword: true)
                Button(action: {
                    Task {
                        isLoading = true
                        let isLogged = await viewModel.login(LoginRequest(email: email, password: password))
                        isLoading = false
                        showAlert = !isLogged
                    }
                }, label: {
                    ButtonView(text: "Entrar")
                })
                .disabled(isLoading)

                NavigationLink {
                    SignUpView()
                } label: {
                    Text("Ainda Não possui uma conta? Cadastre-se.")
                        .bold()
                        .foregroundStyle(.accent)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarBackButtonHidden()
            .padding()
            .alert("Ops, algo deu errado!", isPresented: $showAlert) {
                Button {} label: {
                    Text("Ok")
                }
            } message: {
                Text("Houve um erro ao entrar na sua conta. Por favor tente novamente.")
            }

            if isLoading {
                Color(.black)
                    .opacity(0.3)
                    .blur(radius: 100)
                    .zIndex(1)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                    .scaleEffect(2.0, anchor: .center)
                    .zIndex(2)
            }
        }
    }
}

struct SignInHeaderView: View {
    var body: some View {
        Image(.logo)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 36, alignment: .center)
        Text("Olá!")
            .font(.title2)
            .bold()
            .foregroundStyle(.accent)

        Text("Preencha para acessar sua conta.")
            .font(.title3)
            .bold()
            .foregroundStyle(.gray)
            .padding(.bottom)
    }
}

#Preview {
    SignInView()
}
