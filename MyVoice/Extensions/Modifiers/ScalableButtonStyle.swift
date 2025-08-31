//
//  ScalableButtonStyle.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 31/08/2025.
//

import SwiftUI

struct ScalableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.bouncy(duration: 0.3), value: configuration.isPressed)
    }
}

extension View {
    func scaledWhenPressed() -> some View {
        buttonStyle(ScalableButtonStyle())
    }
}

