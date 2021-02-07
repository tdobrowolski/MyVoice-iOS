//
//  MainTextView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit

final class MainTextView: UITextView {
    
    private var shadowLayer: CAShapeLayer!

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
        self.textContainerInset = UIEdgeInsets(top: 13, left: 14, bottom: 14, right: 13)
        self.font = UIFont(name: "Poppins-Bold", size: 20)
        self.textColor = UIColor(named: "Black") ?? .black
        self.clipsToBounds = false
        self.returnKeyType = .done
        self.tintColor = UIColor(named: "Orange (Main)") // FIXME: Tint not working
    }
    
    private func addShadow(color: UIColor = .black, alpha: Float = 0.2, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
            shadowLayer.fillColor = UIColor(named: "White")?.cgColor
            
            shadowLayer.shadowColor = color.cgColor
            shadowLayer.shadowOffset = CGSize(width: x, height: y)
            shadowLayer.shadowOpacity = alpha
            shadowLayer.shadowRadius = blur / 2
            if spread == 0 {
                layer.shadowPath = nil
            } else {
                let dx = -spread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            }
            
            layer.insertSublayer(shadowLayer, at: 0)
        } else {
            self.shadowLayer.fillColor = UIColor(named: "White")?.cgColor
            shadowLayer.shadowOpacity = alpha
        }
    }
}
