//
//  InfoButton.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 07/10/2023.
//

import UIKit

class InfoButton: UIButton {
    enum `Type` {
        case primary
        case secondary
        
        var titleFont: UIFont { Fonts.Poppins.medium(14.0).font }
        
        var titleColor: UIColor { .purpleMain ?? .purple }
        
        var backgroundColor: UIColor {
            switch self {
            case .primary: return .purpleLight ?? .purple.withAlphaComponent(0.3)
            case .secondary: return .clear
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .primary: return 0.0
            case .secondary: return 1.5
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .primary: return .clear
            case .secondary: return .purpleLight ?? .purple.withAlphaComponent(0.3)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupLayout()
    }
    
    private func setupLayout() {
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpOutside)
    }
    
    func setupLayout(forTitle title: String, type: `Type`) {
        titleLabel?.text = title
        titleLabel?.font = type.titleFont
        
        setTitleColor(type.titleColor, for: .normal)
        backgroundColor = type.backgroundColor
        
        layer.cornerRadius = 8.0
        layer.cornerCurve = .continuous
        layer.borderWidth = type.borderWidth
        layer.borderColor = type.borderColor.cgColor
    }
    
    // MARK: Handle button touch state
    
    @objc
    private func buttonPressed() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func buttonReleased() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.transform = CGAffineTransform.identity
        }
    }
}
