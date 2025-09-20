//
//  UIView+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit

extension UIView {
    /// Adds shadow with values from Sketch App 
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.2,
        x: CGFloat = 0.0,
        y: CGFloat = 2.0,
        blur: CGFloat = 4.0,
        spread: CGFloat = 0.0)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2.0
        if spread == 0.0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
