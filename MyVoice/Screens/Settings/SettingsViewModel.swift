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
        self.sections.onNext(self.getAvailableSettings())
    }
    
    private func getAvailableSettings() -> [SettingsSection] {
        // Section 1
        let languageSetting = SettingModel(primaryText: "Speech voice", secondaryText: "Default") // TODO: Get real voice which is set
        
        // Section 2
        let rateSetting = SettingModel(primaryText: "", secondaryText: nil)
        
        // Section 3
        let pitchSetting = SettingModel(primaryText: "", secondaryText: nil)
        
        // Section 4
        let rateAppSetting = SettingModel(primaryText: "Rate this app", secondaryText: nil)
        let feedbackSetting = SettingModel(primaryText: "Send feedback", secondaryText: nil)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "Unknown"
        
        return [SettingsSection(type: .speechVoice,
                                footer: "Language and voice, which is used for speaking phrases. This will not affect your system language.",
                                items: [languageSetting]),
                SettingsSection(type: .speechRate,
                                footer: "Set how fast your phrases should be spoken.",
                                items: [rateSetting]),
                SettingsSection(type: .speechPitch,
                                footer: "Voice pitch, used for speaking phrases.",
                                items: [pitchSetting]),
                SettingsSection(type: .other,
                                footer: "Version: \(appVersion)",
                                items: [rateAppSetting, feedbackSetting])]
    }
}
