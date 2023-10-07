//
//  SettingsViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 27/01/2021.
//

import RxSwift
import AVFoundation

final class SettingsViewModel: BaseViewModel {
    let sections = BehaviorSubject<[SettingsSection]>(value: [])
    let personalVoiceAuthorizationStatus = BehaviorSubject<PersonalVoiceAuthorizationStatus>(value: .unsupported)
    let personalVoiceService: PersonalVoiceService
    
    private let userDefaultsService: UserDefaultsService
    private let textToSpeechService: TextToSpeechService
    private let feedbackGenerator: UIImpactFeedbackGenerator
    
    override init() {
        self.personalVoiceService = PersonalVoiceService()
        self.userDefaultsService = UserDefaultsService()
        self.textToSpeechService = TextToSpeechService() // TODO: Refactor to pass existing service
        self.feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

        super.init()

        bind()
        refreshSelectedVoiceLabel()
    }
    
    private func bind() {
        personalVoiceService.authorizationStatus
            .bind(to: personalVoiceAuthorizationStatus)
            .disposed(by: disposeBag)
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
        let personalVoiceSetting = SettingModel(
            primaryText: NSLocalizedString("Personal Voice access", comment: ""),
            secondaryText: try? personalVoiceService.authorizationStatus.value().title
        )
        
        // Section 5
        let rateAppSetting = SettingModel(primaryText: NSLocalizedString("Rate this app", comment: ""), secondaryText: nil)
        let feedbackSetting = SettingModel(primaryText: NSLocalizedString("Send feedback", comment: ""), secondaryText: nil)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? NSLocalizedString("Unknown", comment: "")
        
        var sections = [
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
                            items: [rateAppSetting, feedbackSetting])
        ]
        
        if #available(iOS 17.0, *) {
            sections.insert(
                SettingsSection(type: .personalVoice,
                                footer: NSLocalizedString("You can use Personal Voice - a synthesized voice that sounds like your own in the app, only if you grant access to it.", comment: ""),
                                items: [personalVoiceSetting]),
                at: 3
            )
        }
        
        return sections
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
    
    func getDataTypeForSpeechRate() -> SliderDataType {
        let minValue = SliderDataType.minSpeechRateValue
        let maxValue = SliderDataType.maxSpeechRateValue
        var currentValue = userDefaultsService.getSpeechRate()
        if currentValue < minValue || currentValue > maxValue {
            currentValue = SliderDataType.defaultSpeechRateValue
        }

        return .speechRate(currentValue: currentValue)
    }
    
    func getDataTypeForSpeechPitch() -> SliderDataType {
        let minValue = SliderDataType.minSpeechPitchValue
        let maxValue = SliderDataType.maxSpeechPitchValue
        var currentValue = userDefaultsService.getSpeechPitch()
        if currentValue < minValue || currentValue > maxValue {
            currentValue = SliderDataType.defaultSpeechPitchValue
        }

        return .speechPitch(currentValue: currentValue)
    }
        
    func setSpeechRate(_ value: Float) {
        userDefaultsService.setSpeechRate(for: value)
    }
    
    func setSpeechPitch(_ value: Float) {
        userDefaultsService.setSpeechPitch(for: value)
    }
    
    func didSetSliderToCenter() {
        feedbackGenerator.impactOccurred()
    }
}
