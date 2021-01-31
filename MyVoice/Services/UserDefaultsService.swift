//
//  UserDefaultsService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 31/01/2021.
//

import Foundation

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
    
    func getSpeechRate() -> Float? {
        return defaults.float(forKey: Keys.speechRate.rawValue)
    }
    
    func setSpeechPitch(for pitch: Float) {
        defaults.setValue(pitch, forKey: Keys.speechPitch.rawValue)
    }
    
    func getSpeechPitch() -> Float? {
        return defaults.float(forKey: Keys.speechPitch.rawValue)
    }
    
    func setSpeechLanguage(for pitch: Float) {
        defaults.setValue(pitch, forKey: Keys.speechLanguage.rawValue)
    }
    
    func getSpeechLanguage() -> Float? {
        return defaults.float(forKey: Keys.speechLanguage.rawValue)
    }
}
