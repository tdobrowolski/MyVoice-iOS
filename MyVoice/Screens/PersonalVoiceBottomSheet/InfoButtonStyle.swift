//
//  InfoButtonStyle.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 11/11/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct InfoButtonStyle: ButtonStyle {
    enum `Type` {
        case primary
        case secondary

        var titleFont: Font {
            switch self {
            case .primary: return Fonts.Poppins.semibold(14.0).swiftUIFont
            case .secondary: return Fonts.Poppins.medium(14.0).swiftUIFont
            }
        }

        var titleColor: Color { UIColor.purpleMain?.asColor ?? .purple }

        var backgroundColor: Color {
            switch self {
            case .primary: return UIColor.purpleLight?.asColor ?? .purple.opacity(0.3)
            case .secondary: return (UIColor.purpleLight?.asColor ?? .purple).opacity(0.001)
            }
        }

        var borderWidth: CGFloat {
            switch self {
            case .primary: return 0.0
            case .secondary: return 2.0
            }
        }

        var borderColor: Color {
            switch self {
            case .primary: return .clear
            case .secondary: return UIColor.purpleLight?.asColor ?? .purple.opacity(0.3)
            }
        }
    }

    let type: Type

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(type.titleColor)
            .background(type.backgroundColor)
            .cornerRadius(8.0)
            .font(type.titleFont)
            .allowsTightening(true)
            .overlay {
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(type.borderColor, lineWidth: type.borderWidth)
            }
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(
                .easeOut(duration: 0.15),
                value: configuration.isPressed
            )
    }
}
