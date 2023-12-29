//
//  TextFieldWithTitle.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 27/12/23.
//

import SwiftUI

struct TextFieldWithTitle: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isPassword: Bool?

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
            if isPassword != nil {
                SecureField(placeholder, text: $text)
                    .padding(14)
                    .background(Color(.gray).opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            } else {
                TextField(placeholder, text: $text)
                    .padding(14)
                    .background(Color(.gray).opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled()
            }
        }
    }
}

#Preview {
    TextFieldWithTitle(title: "test", placeholder: "test", text: .constant("test"))
}
