//
//  AVSpeechSynthesisVoiceQuality+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 02/09/2025.
//

import enum AVFAudio.AVSpeechSynthesisVoiceQuality
import Foundation
import class UIKit.UIColor

extension AVSpeechSynthesisVoiceQuality {
    var title: String {
        switch self {
        case .default: NSLocalizedString("Default quality", comment: "Default quality")
        case .enhanced: NSLocalizedString("Enhanced quality", comment: "Enhanced quality")
        case .premium: NSLocalizedString("Premium quality", comment: "Premium quality")
        @unknown default: NSLocalizedString("Unknown quality", comment: "Unknown quality")
        }
    }

    var foregroundColor: UIColor {
        switch self {
        case .default: .blueDark ?? .black
        case .enhanced, .premium: .orangeMain ?? .orange
        @unknown default: .blueDark ?? .black
        }
    }
}
