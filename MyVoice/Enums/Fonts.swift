//
//  Fonts.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/06/2023.
//

import Foundation
import UIKit.UIFont

enum Fonts {
    enum Poppins {
        case regular(CGFloat)
        case medium(CGFloat)
        case semibold(CGFloat)
        case bold(CGFloat)
        
        var font: UIFont {
            switch self {
            case let .regular(size):
                return UIFont(name: "Poppins-Regular", size: size) ?? .systemFont(ofSize: size)
                
            case let .medium(size):
                return UIFont(name: "Poppins-Medium", size: size) ?? .systemFont(ofSize: size)
                
            case let .semibold(size):
                return UIFont(name: "Poppins-SemiBold", size: size) ?? .boldSystemFont(ofSize: size)
                
            case let .bold(size):
                return UIFont(name: "Poppins-Bold", size: size) ?? .boldSystemFont(ofSize: size)
            }
        }
    }
}
