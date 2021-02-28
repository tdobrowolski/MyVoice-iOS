//
//  MainTextView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit

final class MainTextView: UITextView {
    
    private var shadowLayer: CAShapeLayer!
    
    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect.zero)
        toolbar.tintColor = UIColor(named: "Orange (Main)")
        toolbar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTap))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17)], for: .normal)
        toolbar.items = [leftSpace, doneButton]
        
        return toolbar
    }()

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
        self.tintColor = UIColor(named: "Orange (Main)")
        self.inputAccessoryView = toolbar
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
    
    @objc
    private func doneButtonDidTap() {
        self.resignFirstResponder()
    }
}
