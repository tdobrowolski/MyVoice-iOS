//
//  MainTextViewBackgroundView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 07/03/2021.
//

import UIKit

final class MainTextViewBackgroundView: UIView {
    private lazy var liquidBackgroundView: UIVisualEffectView = {
        UIVisualEffectView()
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = System.cornerRadius

        if #available(iOS 26.0, *) {
            setupLiquidBackground()
        } else {
            setupShadow()
        }
    }

    @available(iOS 26.0, *)
    private func setupLiquidBackground() {
        insertSubview(liquidBackgroundView, at: 0)
        liquidBackgroundView.frame = bounds
        liquidBackgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        liquidBackgroundView.cornerConfiguration = .corners(radius: .init(floatLiteral: System.cornerRadius))

        let glassEffect = UIGlassEffect()
        glassEffect.tintColor = .whiteCustom
        glassEffect.isInteractive = true

        UIView.animate { liquidBackgroundView.effect = glassEffect }
    }

    private func setupShadow() {
        switch traitCollection.userInterfaceStyle {
        case .light: addShadow(color: .blueDark ?? .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 12.0, spread: -2.0)
        default: addShadow(color: .blueDark ?? .black, alpha: 0.0, x: 0.0, y: 2.0, blur: 12.0, spread: -2.0)
        }
    }

    private func addShadow(
        color: UIColor = .black,
        alpha: Float = 0.2,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0
    ) {
        applySketchShadow(color: color, alpha: alpha, x: x, y: y, blur: blur, spread: spread)
    }
}
