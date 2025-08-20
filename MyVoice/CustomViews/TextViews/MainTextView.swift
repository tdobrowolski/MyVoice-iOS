//
//  MainTextView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit

final class MainTextView: UITextView {
    // TODO: Debug on iPad, when orientation changes
    lazy var accessoryView: UIInputView = {
        ToolbarInputAccessoryView(
            frame: frame,
            pasteboardButtonDidTap: pasteboardButtonDidTap,
            clearTextButtonDidTap: clearTextButtonDidTap,
            hideKeyboardButtonDidTap: hideKeyboardButtonDidTap
        )
    }()

    lazy var backgroundView: UIView = {
        if #available(iOS 26.0, *) {
            return UIVisualEffectView()
        } else {
            return UIView()
        }
    }()

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

        setupBackground()

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

    private func setupBackground() {
        insertSubview(backgroundView, at: 0)
        backgroundView.frame = bounds
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        if #available(iOS 26.0, *) {
            let glassEffect = UIGlassEffect()
            glassEffect.tintColor = .whiteCustom

            backgroundView.cornerConfiguration = .corners(radius: .init(floatLiteral: System.cornerRadius))

            UIView.animate { (backgroundView as? UIVisualEffectView)?.effect = glassEffect }
        } else {
            backgroundView.backgroundColor = .whiteCustom ?? .white
        }
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

    private func clearTextButtonDidTap() { text = nil }

    private func hideKeyboardButtonDidTap() { resignFirstResponder() }
}

// TODO: Make whole TextView tapable
// TODO: Experiment with shadow configuration
// TODO: Experiment with tint color
// TODO: Debug how isInteractive works and why it's so strange looking
