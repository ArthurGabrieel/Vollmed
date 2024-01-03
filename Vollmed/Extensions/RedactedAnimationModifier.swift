//
//  RedactedAnimationModifier.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 03/01/24.
//

import SwiftUI

struct RedactedAnimationModifier: ViewModifier {
    @State private var isRedacted = true
    func body(content: Content) -> some View {
        content
            .opacity(isRedacted ? 0 : 1)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    self.isRedacted.toggle()
                }
            }
    }
}

extension View {
    func redactedAnimation() -> some View {
        modifier(RedactedAnimationModifier())
    }
}
