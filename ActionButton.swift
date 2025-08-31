//
//  ActionButton.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 22/08/2025.
//

import SwiftUI

// TODO: Debug if speak volume state is changing the speaker icon

struct ActionButton: View {
    let type: ActionButtonType
    let onTap: () -> ()

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
                onTap()
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
            onTap()
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
        .scaledWhenPressed()
    }

    // TODO: Tweak spacing
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

    private var icon: some View {
        Circle()
            .fill(type.getBackgroundColor(isSpeaking: state.isSpeaking) ?? .white)
            .frame(width: 50.0, height: 50.0)
            .overlay {
                if #available(iOS 17.0, *) {
                    symbol
                        .contentTransition(.symbolEffect(.replace))
                } else {
                    symbol
                }
            }
    }

    private var symbol: some View {
        Image(
            systemName: type.getIconName(
                with: state.systemVolumeState,
                isSpeaking: state.isSpeaking
            )
        )
        .renderingMode(.template)
        .foregroundColor(type.getTintColor(isSpeaking: state.isSpeaking) ?? .black)
        .font(.title3.bold()) // TODO: Check with design if correct
        .dynamicTypeSize(.medium)
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
            onTap: {},
            state: state
        )
        ActionButton(
            type: .display,
            onTap: {},
            state: state
        )
        ActionButton(
            type: .save,
            onTap: {},
            state: state
        )
    }
    .frame(height: 120.0)
    .padding(.horizontal, 16.0)
}
