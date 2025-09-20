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
        backgroundColor = .whiteCustom


        if #available(iOS 26.0, *) {
            setupLiquidGlassLayout()
        } else {
            setupLegacyShadow()
        }
    }

    @available(iOS 26.0, *)
    private func setupLiquidGlassLayout() {
        switch traitCollection.userInterfaceStyle {
        case .light:
            setupLiquidBackground(isHidden: true)
            applyShadow(color: .blueDark ?? .black, alpha: 0.15, y: 4.0, blur: 16.0, spread: -2.0)
        default:
            setupLiquidBackground(isHidden: false)
            applyShadow(color: .blueDark ?? .black, alpha: 0.0, y: 4.0, blur: 16.0, spread: -2.0)
        }
    }

    @available(iOS 26.0, *)
    private func setupLiquidBackground(isHidden: Bool) {
        insertSubview(liquidBackgroundView, at: 0)
        liquidBackgroundView.isHidden = isHidden
        liquidBackgroundView.frame = bounds
        liquidBackgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        liquidBackgroundView.cornerConfiguration = .corners(radius: .init(floatLiteral: System.cornerRadius))

        let glassEffect = UIGlassEffect()
        glassEffect.tintColor = .whiteCustom
        glassEffect.isInteractive = true

        UIView.animate { liquidBackgroundView.effect = glassEffect }
    }

    private func setupLegacyShadow() {
        switch traitCollection.userInterfaceStyle {
        case .light:
            applyShadow(color: .blueDark ?? .black, alpha: 0.1, y: 2.0, blur: 12.0, spread: -2.0)
        default:
            applyShadow(color: .blueDark ?? .black, alpha: 0.0, y: 2.0, blur: 12.0, spread: -2.0)
        }
    }
}

fileprivate extension UIUserInterfaceStyle {
    var isLiquidGlassLayerHidden: Bool {
        self == .light
    }
}
