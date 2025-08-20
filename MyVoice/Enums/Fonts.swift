//
//  Fonts.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/06/2023.
//

import Foundation
import UIKit.UIFont
import SwiftUI

enum Fonts {
    enum Poppins {
        case regular(CGFloat)
        case medium(CGFloat)
        case semibold(CGFloat)
        case bold(CGFloat)
        
        var font: UIFont {
            switch self {
            case let .regular(size):
                return fontMetrics.scaledFont(for: UIFont(name: "Poppins-Regular", size: size) ?? .systemFont(ofSize: size))
                
            case let .medium(size):
                return fontMetrics.scaledFont(for: UIFont(name: "Poppins-Medium", size: size) ?? .systemFont(ofSize: size))
                
            case let .semibold(size):
                return fontMetrics.scaledFont(for: UIFont(name: "Poppins-SemiBold", size: size) ?? .boldSystemFont(ofSize: size))
                
            case let .bold(size):
                return fontMetrics.scaledFont(for: UIFont(name: "Poppins-Bold", size: size) ?? .boldSystemFont(ofSize: size))
            }
        }
        
        var swiftUIFont: Font { .init(font) }
        
        var fontMetrics: UIFontMetrics {
            switch self {
            case let .regular(size):
                switch size {
                case 15.0: return .init(forTextStyle: .subheadline)
                case 12.0: return .init(forTextStyle: .caption1)
                default: return .init(forTextStyle: .body)
                }
                
            case let .medium(size):
                switch size {
                case 17.0: return .init(forTextStyle: .body)
                case 15.0: return .init(forTextStyle: .subheadline)
                case 14.0: return .init(forTextStyle: .subheadline)
                case 13.0: return .init(forTextStyle: .footnote)
                default: return .init(forTextStyle: .body)
                }
                
            case let .semibold(size), let .bold(size):
                switch size {
                case 72.0: return .init(forTextStyle: .largeTitle)
                case 20.0: return .init(forTextStyle: .title3)
                case 17.0, 18.0: return .init(forTextStyle: .headline)
                case 15.0: return .init(forTextStyle: .subheadline)
                case 14.0: return .init(forTextStyle: .subheadline)
                default: return .init(forTextStyle: .headline)
                }
            }
        }
    }
}
