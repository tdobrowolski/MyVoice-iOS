//
//  MainTextView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit

final class MainTextView: UITextView {
    private var shadowLayer: CAShapeLayer?

    // TODO: Debug on iPad, when orientation changes
    lazy var accessoryView: UIInputView = {
        ToolbarInputAccessoryView(
            frame: frame,
            pasteboardButtonDidTap: pasteboardButtonDidTap,
            clearTextButtonDidTap: clearTextButtonDidTap,
            hideKeyboardButtonDidTap: hideKeyboardButtonDidTap
        )
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
        
        backgroundColor = .whiteCustom ?? .white
        textColor = .blackCustom ?? .black
        tintColor = .orangeMain
        
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

    private func addShadow(
        color: UIColor = .black,
        alpha: Float = 0.2,
        x: CGFloat = 0.0,
        y: CGFloat = 2.0,
        blur: CGFloat = 4.0,
        spread: CGFloat = 0.0
    ) {
        shadowLayer?.removeFromSuperlayer()
        shadowLayer = CAShapeLayer()
        shadowLayer?.path = UIBezierPath(roundedRect: bounds, cornerRadius: System.cornerRadius).cgPath
        shadowLayer?.fillColor = UIColor.whiteCustom?.cgColor
        
        shadowLayer?.shadowColor = color.cgColor
        shadowLayer?.shadowOffset = CGSize(width: x, height: y)
        shadowLayer?.shadowOpacity = alpha
        shadowLayer?.shadowRadius = blur / 2

        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }

        layer.insertSublayer(shadowLayer!, at: 0)
    }

    private func pasteboardButtonDidTap() {
        if UIPasteboard.general.hasStrings {
            text = UIPasteboard.general.string
        }
    }

    private func clearTextButtonDidTap() { text = nil }

    private func hideKeyboardButtonDidTap() { resignFirstResponder() }
}
