//
//  AVSpeechSynthesizer+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 30/10/2023.
//

import AVFoundation

@available(iOS 17.0, *)
extension AVSpeechSynthesizer.PersonalVoiceAuthorizationStatus {
    var asDomain: PersonalVoiceAuthorizationStatus {
        switch self {
        case .notDetermined: return .notDetermined
        case .denied: return .denied
        case .unsupported: return .unsupported
        case .authorized: return .authorized
        @unknown default: return .unsupported
        }
    }
}
