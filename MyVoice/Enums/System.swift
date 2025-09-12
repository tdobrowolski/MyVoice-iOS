//
//  System.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 31/08/2025.
//

import Foundation
import UIKit

enum System {
    static var supportsLiquidGlass: Bool {
        if #available(iOS 26.0, *) {
            return true
        } else {
            return false
        }
    }

    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var cornerRadius: CGFloat {
        supportsLiquidGlass ? 26.0 : 16.0
    }

    static var defaultOrientation: UIInterfaceOrientationMask {
        isPad ? .all : .portrait
    }

    static var displayTextOrientation: UIInterfaceOrientationMask {
        isPad ? .all : .allButUpsideDown
    }
}
