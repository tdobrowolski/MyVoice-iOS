//
//  UILabel+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 27/01/2021.
//

import UIKit

extension UILabel {
    func flashWithColor(_ flashColor: UIColor) {
        guard tag != 1 else { return }

        let defaultColor: UIColor = textColor ?? .black
        let changeColor = CATransition()
        changeColor.type = .fade
        changeColor.duration = 0.5

        CATransaction.begin()
        tag = 1

        CATransaction.setCompletionBlock { [weak self] in
            self?.layer.add(changeColor, forKey: nil)
            self?.textColor = defaultColor
            self?.tag = 0
        }

        layer.add(changeColor, forKey: nil)
        textColor = flashColor

        CATransaction.commit()
    }
}
