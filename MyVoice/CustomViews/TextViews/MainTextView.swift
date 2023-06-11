//
//  MainTextView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit

final class MainTextView: UITextView {
    private var shadowLayer: CAShapeLayer?
    
    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect.zero)
        toolbar.tintColor = .orangeMain
        toolbar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(
            title: NSLocalizedString("Done", comment: "Done"),
            style: .done,
            target: self,
            action: #selector(doneButtonDidTap)
        )
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: Fonts.Poppins.semibold(17.0).font], for: .normal)
        toolbar.items = [leftSpace, doneButton]
        
        return toolbar
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        setupLayout()
//        switch traitCollection.userInterfaceStyle {
//        case .light:
//            self.addShadow(color: .blueDark ?? .black, alpha: 0.25, x: 0, y: 2, blur: 12, spread: -2)
//        default:
//            self.addShadow(color: .blueDark ?? .black, alpha: 0.0, x: 0, y: 2, blur: 12, spread: -2)
//        }
    }

    private func setupLayout() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        clipsToBounds = false
        
        backgroundColor = .whiteCustom ?? .white
        textColor = .blackCustom ?? .black
        tintColor = .orangeMain
        textContainerInset = UIEdgeInsets(top: 13, left: 14, bottom: 14, right: 13)
        font = Fonts.Poppins.bold(20.0).font
        
        returnKeyType = .done
        inputAccessoryView = toolbar
    }
    
    private func addShadow(color: UIColor = .black, alpha: Float = 0.2, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        shadowLayer?.removeFromSuperlayer()
        shadowLayer = CAShapeLayer()
        shadowLayer?.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
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
    
    @objc
    private func doneButtonDidTap() { resignFirstResponder() }
}
