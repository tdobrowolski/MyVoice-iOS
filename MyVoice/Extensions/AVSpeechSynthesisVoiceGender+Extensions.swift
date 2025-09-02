//
//  AVSpeechSynthesisVoiceGender+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 02/09/2025.
//

import enum AVFAudio.AVSpeechSynthesisVoiceGender
import Foundation

extension AVSpeechSynthesisVoiceGender {
    var title: String {
        switch self {
        case .male: NSLocalizedString("Male", comment: "Male")
        case .female: NSLocalizedString("Female", comment: "Female")
        case .unspecified: NSLocalizedString("Unspecified", comment: "Unspecified")
        @unknown default: NSLocalizedString("Unspecified", comment: "Unspecified")
        }
    }
}
