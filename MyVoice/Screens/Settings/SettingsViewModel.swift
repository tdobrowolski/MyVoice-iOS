//
//  SettingsViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 27/01/2021.
//

import RxSwift
import AVFoundation

final class SettingsViewModel: BaseViewModel {
    private let userDefaultsService: UserDefaultsService
    private let textToSpeechService: TextToSpeechService
    
    let sections = BehaviorSubject<[SettingsSection]>(value: [])
    
    override init() {
        self.userDefaultsService = UserDefaultsService()
        self.textToSpeechService = TextToSpeechService() // TODO: Refactor to pass existing service

        super.init()

        refreshSelectedVoiceLabel()
    }
    
    private func getAvailableSettings() -> [SettingsSection] {
        // Section 1
        let languageSetting = SettingModel(
            primaryText: NSLocalizedString("Speech voice", comment: "Speech voice"),
            secondaryText: getSelectedVoiceName()
        )
        
        // Section 2
        let rateSetting = SettingModel(primaryText: "", secondaryText: nil)
        
        // Section 3
        let pitchSetting = SettingModel(primaryText: "", secondaryText: nil)
        
        // Section 4
        let rateAppSetting = SettingModel(primaryText: NSLocalizedString("Rate this app", comment: ""), secondaryText: nil)
        let feedbackSetting = SettingModel(primaryText: NSLocalizedString("Send feedback", comment: ""), secondaryText: nil)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? NSLocalizedString("Unknown", comment: "")
        
        return [
            SettingsSection(type: .speechVoice,
                            footer: NSLocalizedString("Language and voice, which is used for speaking phrases. This will not affect your system language.", comment: ""),
                            items: [languageSetting]),
            SettingsSection(type: .speechRate,
                            footer: NSLocalizedString("Set how fast your phrases should be spoken.", comment: ""),
                            items: [rateSetting]),
            SettingsSection(type: .speechPitch,
                            footer: NSLocalizedString("Voice pitch, used for speaking phrases.", comment: ""),
                            items: [pitchSetting]),
            SettingsSection(type: .other,
                            footer: NSLocalizedString("Version:", comment: "").appending(" \(appVersion)"),
                            items: [feedbackSetting])
        ] // TODO: Add rateAppSetting if AppStore URL available
    }
    
    func getSelectedVoiceName() -> String {
        if let selectedVoiceIdentifier = userDefaultsService.getSpeechVoiceIdentifier(), let selectedVoice = AVSpeechSynthesisVoice(identifier: selectedVoiceIdentifier) {
            let fullLanguage = NSLocale(localeIdentifier: NSLocale.current.identifier).localizedString(forLanguageCode: selectedVoice.language) ?? NSLocalizedString("Default", comment: "")

            return "\(fullLanguage) - \(selectedVoice.name)"
        } else {
            let defaultLanguageIdentifier = AVSpeechSynthesisVoice.currentLanguageCode()
            if let defaultVoice = AVSpeechSynthesisVoice(language: defaultLanguageIdentifier) {
                let fullLanguage = NSLocale(localeIdentifier: NSLocale.current.identifier).localizedString(forLanguageCode: defaultVoice.language) ?? NSLocalizedString("Default", comment: "")

                return "\(fullLanguage) - \(defaultVoice.name)"
            } else {
                return NSLocalizedString("Default", comment: "")
            }
        }
    }
    
    func refreshSelectedVoiceLabel() {
        sections.onNext(getAvailableSettings())
    }
    
    func getDataTypeForSpeechRate() -> SliderTableViewCell.SliderDataType {
        let minValue = AVSpeechUtteranceMinimumSpeechRate
        let maxValue = AVSpeechUtteranceMaximumSpeechRate
        var currentValue = userDefaultsService.getSpeechRate()
        if currentValue < minValue || currentValue > maxValue {
            currentValue = AVSpeechUtteranceDefaultSpeechRate
        }

        return SliderTableViewCell.SliderDataType.speechRate(currentValue: currentValue, minValue: minValue, maxValue: maxValue)
    }
    
    func getDataTypeForSpeechPitch() -> SliderTableViewCell.SliderDataType {
        let minValue: Float = 0.0
        let maxValue: Float = 2.0
        var currentValue = userDefaultsService.getSpeechPitch()
        if currentValue < minValue || currentValue > maxValue {
            currentValue = 1.0
        }

        return SliderTableViewCell.SliderDataType.speechPitch(
            currentValue: currentValue,
            minValue: minValue,
            maxValue: maxValue
        )
    }
    
    func setSpeechRate(_ value: Float) {
        userDefaultsService.setSpeechRate(for: value)
    }
    
    func setSpeechPitch(_ value: Float) {
        userDefaultsService.setSpeechPitch(for: value)
    }
}
