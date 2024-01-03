//
//  SnackBarErrorView.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 03/01/24.
//

import SwiftUI

struct SnackBarErrorView: View {
    @Binding var isShowing: Bool
    var message: String
    
    var body: some View {
        VStack {
            Spacer()
            if isShowing {
                Text(message)
                    .padding()
                    .background(Color(.red))
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 10))
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeInOut) {
                                isShowing = false
                            }
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.bottom, isShowing ? 
                 UIApplication.shared.getKeyWindow?.safeAreaInsets.bottom ?? 0 : -100)
    }
}

#Preview {
    SnackBarErrorView(isShowing: .constant(true), message: "Ocorreu um erro, mas já estamos trabalhando para solucionar.")
}
