//
//  SettingsViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 27/01/2021.
//

import RxSwift

final class SettingsViewModel: BaseViewModel {
    
    private let userDefaultsService: UserDefaultsService
    
    let sections = BehaviorSubject<[SettingsSection]>(value: [])
    
    override init() {
        self.userDefaultsService = UserDefaultsService()
        super.init()
        self.sections.onNext(self.getAvailableSettings())
    }
    
    private func getAvailableSettings() -> [SettingsSection] {
        // Section 1
        let languageSetting = SettingModel(primaryText: "Speech language", secondaryText: "Default") // TODO: Get real language which is set
        
        // Section 2
        let rateSetting = SettingModel(primaryText: "", secondaryText: nil)
        
        // Section 3
        let pitchSetting = SettingModel(primaryText: "", secondaryText: nil)
        
        // Section 4
        let rateAppSetting = SettingModel(primaryText: "Rate this app", secondaryText: nil)
        let feedbackSetting = SettingModel(primaryText: "Send feedback", secondaryText: nil)
        
        // TODO: Set info about Infinity and app version/build number
        return [SettingsSection(type: .speechLanguage,
                                footer: "Language, which is used for speaking phrases. This will not affect your system language.",
                                items: [languageSetting]),
                SettingsSection(type: .speechRate,
                                footer: "Set how fast your phrases should be spoken.",
                                items: [rateSetting]),
                SettingsSection(type: .speechPitch,
                                footer: "Voice pitch, used for speaking phrases.",
                                items: [pitchSetting]),
                SettingsSection(type: .other,
                                items: [rateAppSetting, feedbackSetting])]
    }
}
