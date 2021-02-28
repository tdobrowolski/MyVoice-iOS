//
//  UILabel+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 27/01/2021.
//

import UIKit

extension UILabel {
    
    func flashWithColor(_ flashColor: UIColor) {

        if self.tag == 1 { return }
        let defaultColor: UIColor = self.textColor ?? .black

        let changeColor = CATransition()
        changeColor.type = .fade
        changeColor.duration = 0.5

        CATransaction.begin()
        self.tag = 1
        CATransaction.setCompletionBlock { [weak self] in
            self?.layer.add(changeColor, forKey: nil)
            self?.textColor = defaultColor
            self?.tag = 0
        }
        self.layer.add(changeColor, forKey: nil)
        self.textColor = flashColor

        CATransaction.commit()
    }
}
