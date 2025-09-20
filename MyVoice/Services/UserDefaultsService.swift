//
//  UserDefaultsService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 31/01/2021.
//

import Foundation

final class UserDefaultsService {
    private let defaults = UserDefaults.standard
    
    private enum Keys: String {
        case speechRate = "SpeechRate"
        case speechPitch = "SpeechPitch"
        case speechLanguage = "SpeechLanguage"
        case personalVoiceInfo = "PersonalVoiceInfo"
        case appAudioForCalls = "AppAudioForCalls"
    }
    
    // MARK: Speech settings
    
    func setSpeechRate(for rate: Float) {
        defaults.set(rate, forKey: Keys.speechRate.rawValue)
    }
    
    func getSpeechRate() -> Float {
        if defaults.object(forKey: Keys.speechRate.rawValue) != nil {
            return defaults.float(forKey: Keys.speechRate.rawValue)
        } else {
            return SliderDataType.defaultSpeechRateValue
        }
    }
    
    func setSpeechPitch(for pitch: Float) {
        defaults.set(pitch, forKey: Keys.speechPitch.rawValue)
    }
    
    func getSpeechPitch() -> Float {
        if defaults.object(forKey: Keys.speechPitch.rawValue) != nil {
            return defaults.float(forKey: Keys.speechPitch.rawValue)
        } else {
            return SliderDataType.defaultSpeechPitchValue
        }
    }
    
    func setSpeechVoice(for identifier: String) {
        defaults.set(identifier, forKey: Keys.speechLanguage.rawValue)
    }
    
    func getSpeechVoiceIdentifier() -> String? {
        defaults.string(forKey: Keys.speechLanguage.rawValue)
    }
    
    // MARK: Personal Voice info bottom sheet
    
    func setPersonalVoiceInfoToShown() {
        defaults.set(true, forKey: Keys.personalVoiceInfo.rawValue)
    }
    
    var didShowPersonalVoiceInfo: Bool {
        defaults.bool(forKey: Keys.personalVoiceInfo.rawValue)
    }

    // MARK: App Audio For Calls

    func setAppAudioForCalls(enabled: Bool) {
        defaults.set(enabled, forKey: Keys.appAudioForCalls.rawValue)
    }

    func isAppAudioForCallsEnabled() -> Bool {
        return defaults.bool(forKey: Keys.appAudioForCalls.rawValue)
    }
}
