//
//  PersonalVoiceBottomSheetView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 05/11/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct PersonalVoiceBottomSheetView: View {
    @ObservedObject var viewModel: PersonalVoiceBottomSheetViewModel

    @State private var isAnimatingImage = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(UIColor.whiteCustom?.asColor ?? .white)
            content
                .padding(16.0)
        }
        .clipped()
        .padding(14.0)
        .background(
            UIColor.background?.asColor
                .ignoresSafeArea()
        )
    }

    private var content: some View {
        VStack(spacing: 14.0) {
            infoSection
            separator
            buttonsSection
        }
    }

    private var infoSection: some View {
        VStack(spacing: 4.0) {
            title
            subtitle
            VStack(spacing: 2.0) {
                learnMoreButton
                Spacer()
                    .background(
                        ViewThatFits(in: .vertical) {
                            getContentImage(for: 13)
                            getContentImage(for: 12)
                            getContentImage(for: 11)
                            getContentImage(for: 10)
                            getContentImage(for: 9)
                            getContentImage(for: 8)
                            getContentImage(for: 7)
                            getContentImage(for: 6)
                            getContentImage(for: 5)
                            getContentImage(for: 4)
                            getContentImage(for: 3)
                            getContentImage(for: 2)
                        }
                    )
                    .zIndex(-1)
                helperLabel
            }
        }
    }

    private var buttonsSection: some View {
        HStack(spacing: 14.0) {
            closeButton
            if viewModel.accessType.showActionButton {
                actionButton
            }
        }
    }

    private var title: some View {
        Text(NSLocalizedString("Personal Voice now available", comment: ""))
            .foregroundColor(UIColor.blackCustom?.asColor)
            .font(Fonts.Poppins.bold(17.0).swiftUIFont)
            .multilineTextAlignment(.center)
    }

    private var subtitle: some View {
        Text(NSLocalizedString("You can now use your generated Personal Voice to read phrases within the MyVoice app. To use your generated voices, grant access to it.", comment: ""))
            .foregroundColor(UIColor.blueDark?.asColor)
            .font(Fonts.Poppins.semibold(13.0).swiftUIFont)
            .multilineTextAlignment(.center)
            .allowsTightening(true)
    }

    private var learnMoreButton: some View {
        Button {
            viewModel.didTapLearnMore()
        } label: {
            Text(NSLocalizedString("Learn more about Personal Voice", comment: ""))
                .foregroundColor(UIColor.purpleMain?.asColor)
                .font(Fonts.Poppins.semibold(13.0).swiftUIFont)
                .padding(2.0)
        }
    }

    @ViewBuilder
    private func getContentImage(for numberOfRings: Int) -> some View {
        let opacityStep: CGFloat = 1.0 / CGFloat(numberOfRings + 1)

        ZStack {
            ForEach(1...numberOfRings, id: \.self) { i in
                let opacity = 1.0 - (CGFloat(i) * opacityStep)
                let sideSize = 50.0 * CGFloat(i + 1)

                Circle()
                    .fill(.clear)
                    .stroke(
                        (UIColor.purpleLight?.asColor ?? .black).opacity(opacity),
                        lineWidth: 2.0
                    )
                    .frame(width: sideSize, height: sideSize)
                    .scaleEffect(isAnimatingImage ? 1.0 : 0.0)
                    .animation(
                        .bouncy(duration: 2.0).delay(CGFloat(i) * 0.2)
                        ,value: isAnimatingImage
                    )
                    .onAppear { isAnimatingImage = true }
            }
            icon
        }
        .accessibilityHidden(true)
    }

    private var icon: some View {
        Circle()
            .fill(UIColor.purpleLight?.asColor ?? .purple)
            .frame(width: 50.0, height: 50.0)
            .overlay {
                Image(systemName: "sparkles")
                    .resizable()
                    .foregroundColor(UIColor.purpleMain?.asColor)
                    .frame(width: 19.0, height: 19.0)
            }
    }

    @ViewBuilder
    private var helperLabel: some View {
        if let text = viewModel.accessType.helperText {
            Text(text)
                .foregroundColor(UIColor.blueDark?.asColor)
                .font(Fonts.Poppins.semibold(13.0).swiftUIFont)
                .multilineTextAlignment(.center)
        }
    }

    private var separator: some View {
        Rectangle()
            .fill(UIColor.blueLight?.asColor ?? .black)
            .frame(height: 1.0)
    }

    private var closeButton: some View {
        Button(
            action: { viewModel.didTapClose() },
            label: {
                Text(NSLocalizedString("Close", comment: ""))
                    .allowsTightening(true)
                    .minimumScaleFactor(0.8)
                    .frame(height: 44.0)
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(InfoButtonStyle(type: .secondary))
    }

    private var actionButton: some View {
        Button(
            action: {
                Task {
                    await viewModel.didTapActionButtonAccess()
                }
            },
            label: {
                Text(viewModel.accessType.actionButtonText)
                    .allowsTightening(true)
                    .minimumScaleFactor(0.8)
                    .frame(height: 44.0)
                    .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(InfoButtonStyle(type: .primary))
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        PersonalVoiceBottomSheetView(
            viewModel: PersonalVoiceBottomSheetViewModel(
                personalVoiceService: .init(),
                onClose: { }
            )
        )
    } else {
        EmptyView()
    }
}
