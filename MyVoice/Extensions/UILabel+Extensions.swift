//
//  UILabel+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 27/01/2021.
//

import UIKit

extension UILabel {
    
    // TODO: Check if it's smooth on the device
    func flashWithColor(_ flashColor: UIColor) {

        let defaultColor: UIColor = self.textColor ?? .black

        let changeColor = CATransition()
        changeColor.type = .fade
        changeColor.duration = 0.5

        CATransaction.begin()

        CATransaction.setCompletionBlock { [weak self] in
            self?.layer.add(changeColor, forKey: nil)
            self?.textColor = defaultColor
        }
        self.layer.add(changeColor, forKey: nil)
        self.textColor = flashColor

        CATransaction.commit()
    }
}
