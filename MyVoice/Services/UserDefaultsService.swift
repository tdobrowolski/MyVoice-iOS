//
//  UserDefaultsService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 31/01/2021.
//

import Foundation
import AVKit

final class UserDefaultsService {
    
    let defaults = UserDefaults.standard
    
    enum Keys: String {
        case speechRate = "SpeechRate"
        case speechPitch = "SpeechPitch"
        case speechLanguage = "SpeechLanguage"
    }
    
    // MARK: Speech settings
    
    func setSpeechRate(for rate: Float) {
        defaults.setValue(rate, forKey: Keys.speechRate.rawValue)
    }
    
    func getSpeechRate() -> Float {
        if defaults.object(forKey: Keys.speechRate.rawValue) != nil {
            return defaults.float(forKey: Keys.speechRate.rawValue)
        } else {
            return AVSpeechUtteranceDefaultSpeechRate
        }
    }
    
    func setSpeechPitch(for pitch: Float) {
        defaults.setValue(pitch, forKey: Keys.speechPitch.rawValue)
    }
    
    func getSpeechPitch() -> Float {
        if defaults.object(forKey: Keys.speechPitch.rawValue) != nil {
            return defaults.float(forKey: Keys.speechPitch.rawValue)
        } else {
            return 1.0
        }
    }
    
    func setSpeechVoice(for identifier: String) {
        defaults.setValue(identifier, forKey: Keys.speechLanguage.rawValue)
    }
    
    func getSpeechVoiceIdentifier() -> String? {
        return defaults.string(forKey: Keys.speechLanguage.rawValue)
    }
}
