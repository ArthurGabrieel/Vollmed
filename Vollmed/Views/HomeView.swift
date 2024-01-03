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
    @State private var isShowingSnackBar = false
    @State private var errorMessage = ""
    var viewModel = HomeViewModel(homeService: HomeService(),
                                  authService: AuthenticationService())

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
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
                    if isLoading {
                        SkeletonView()
                    } else {
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
                do {
                    if let response = try await viewModel.getSpecialists() {
                        self.specialists = response
                    }
                } catch {
                    isShowingSnackBar = true
                    let errorType = error as? RequestError
                    errorMessage = errorType?.customMessage ?? "Ops! Ocorreu um erro"
                }
                isLoading = false
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.logout()
                        }
                    }, label: {
                        HStack(spacing: 2) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                        }
                    })
                }
            }
            if isShowingSnackBar {
                SnackBarErrorView(isShowing: $isShowingSnackBar, message: errorMessage)
            }
        }
    }
}

#Preview {
    HomeView()
}
