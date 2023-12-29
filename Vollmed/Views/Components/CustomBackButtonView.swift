//
//  CustomBackButtonView.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 26/12/23.
//

import SwiftUI

struct CustomBackButtonView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Voltar")
            }
            .foregroundStyle(.accent)
        }
    }
}

#Preview {
    CustomBackButtonView()
}
