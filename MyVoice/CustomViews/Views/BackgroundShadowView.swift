//
//  BackgroundShadowView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 07/03/2021.
//

import UIKit

final class BackgroundShadowView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
        switch traitCollection.userInterfaceStyle {
        case .light:
            self.addShadow(color: UIColor(named: "Blue (Dark)") ?? .black, alpha: 0.25, x: 0, y: 2, blur: 12, spread: -2)
        default:
            self.addShadow(color: UIColor(named: "Blue (Dark)") ?? .black, alpha: 0.0, x: 0, y: 2, blur: 12, spread: -2)
        }
    }
    
    private func setupLayout() {
        self.layer.cornerRadius = 16
    }
    
    private func addShadow(color: UIColor = .black, alpha: Float = 0.2, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        self.applySketchShadow(color: color, alpha: alpha, x: x, y: y, blur: blur, spread: spread)
    }

}
