//
//  MainTextView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit

final class MainTextView: UITextView {
    private lazy var accessoryView: UIInputView = {
        ToolbarInputAccessoryView(
            frame: frame,
            pasteboardButtonDidTap: pasteboardButtonDidTap,
            clearTextButtonDidTap: clearTextButtonDidTap,
            hideKeyboardButtonDidTap: hideKeyboardButtonDidTap
        )
    }()

    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
        setupTextContent()
    }

    private func setupLayout() {
        layer.cornerRadius = System.cornerRadius
        layer.masksToBounds = true
        clipsToBounds = true

        backgroundColor = .clear
        textColor = .blackCustom ?? .black
        tintColor = .orangeMain

        accessibilityLabel = NSLocalizedString("Phrase", comment: "Phrase")
        accessibilityHint = NSLocalizedString("Tap here to enter phrase.", comment: "Tap here to enter phrase.")
        accessibilityValue = text

        textContainerInset = .init(
            top: 13.0,
            left: 14.0,
            bottom: 14.0,
            right: 13.0
        )
        font = Fonts.Poppins.bold(20.0).font

        inputAccessoryView = accessoryView

        verticalScrollIndicatorInsets = .init(
            top: System.cornerRadius,
            left: .zero,
            bottom: System.cornerRadius,
            right: .zero
        )
    }

    private func setupTextContent() {
        keyboardType = .asciiCapable
        keyboardDismissMode = .interactive
        returnKeyType = .default
    }

    private func pasteboardButtonDidTap() {
        if UIPasteboard.general.hasStrings {
            text = UIPasteboard.general.string
        }
    }

    private func clearTextButtonDidTap() {
        feedbackGenerator.impactOccurred()
        text = nil
    }

    private func hideKeyboardButtonDidTap() { resignFirstResponder() }
}
