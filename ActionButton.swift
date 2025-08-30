//
//  ActionButton.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 22/08/2025.
//

import SwiftUI

struct ActionButton: View {
    let type: ActionType

    @ObservedObject var state: SpeakButtonViewState

    var body: some View {
        if #available(iOS 26.0, *) {
            liquidGlassContent
        } else {
            legacyContent
        }
    }

    @ViewBuilder
    private var liquidGlassContent: some View {
        if #available(iOS 26.0, *) {
            Button {
                // TODO: Add action
            } label: {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(
                .roundedRectangle(radius: System.cornerRadius)
            )
            .tint(UIColor.whiteCustom?.asColor ?? .white)
        }
    }

    // TODO: Tweak shadow
    private var legacyContent: some View {
        Button {
            // TODO: Add action
        } label: {
            ZStack {
                background
                content
            }
            .drawingGroup()
            .shadow(
                color: (UIColor.blueDark?.asColor ?? .black).opacity(0.15),
                radius: 12.0,
                x: 0.0,
                y: 2.0
            )
        }
        .actionButtonStyle()
    }

    private var content: some View {
        VStack(spacing: 8.0) {
            icon
            title
                .padding(.horizontal, 2.0)
        }
        .padding(.vertical, 12.0)
    }

    private var background: some View {
        RoundedRectangle(
            cornerRadius: System.cornerRadius,
            style: .continuous
        )
        .fill(UIColor.whiteCustom?.asColor ?? .white)
    }

    // TODO: Fix icon transition animation
    private var icon: some View {
        Circle()
            .fill(type.getBackgroundColor(isSpeaking: state.isSpeaking)?.asColor ?? .white)
            .frame(width: 50.0, height: 50.0)
            .overlay {
//                if let image = type.getIcon(with: state.systemVolumeState, isSpeaking: state.isSpeaking) {
                    if #available(iOS 17.0, *) {
//                        Image(uiImage: image)
                        Image(systemName: state.isSpeaking ? "stop" : "play")
                            .renderingMode(.template)
                            .foregroundColor(type.getTintColor(isSpeaking: state.isSpeaking)?.asColor ?? .black)
                            .frame(width: 24.0, height: 24.0) // FIXME: Bad way
                            .contentTransition(.symbolEffect(.replace))
                    } else {
//                        Image(uiImage: image)
                        Image(systemName: "play")
                            .renderingMode(.template)
                            .foregroundColor(type.getTintColor(isSpeaking: state.isSpeaking)?.asColor ?? .black)
                            .frame(width: 24.0, height: 24.0) // FIXME: Bad way
                    }
//                }
            }
    }

    private var title: some View {
        Text(type.getTitle(isSpeaking: state.isSpeaking))
            .kerning(0.6)
            .font(Fonts.Poppins.bold(15.0).swiftUIFont)
            .foregroundStyle(UIColor.blackCustom?.asColor ?? .black)
    }
}

#Preview {
    let state = SpeakButtonViewState()

    HStack(spacing: 16.0) {
        ActionButton(
            type: .speak,
            state: state
        )
        ActionButton(
            type: .display,
            state: state
        )
        ActionButton(
            type: .save,
            state: state
        )
    }
    .frame(height: 120.0)
    .padding(.horizontal, 16.0)
}

// TODO: Move

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.bouncy(duration: 0.3), value: configuration.isPressed)
    }
}

extension View {
    func actionButtonStyle() -> some View {
        buttonStyle(ActionButtonStyle())
    }
}
