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
    let isAppAudioForCallsEnabled = BehaviorSubject<Bool>(value: false)

    let personalVoiceService: PersonalVoiceService

    private let userDefaultsService: UserDefaultsService
    private let textToSpeechService: TextToSpeechService
    private let feedbackGenerator: UIImpactFeedbackGenerator
    
    init(personalVoiceService: PersonalVoiceService) {
        self.personalVoiceService = personalVoiceService
        self.userDefaultsService = UserDefaultsService()
        self.textToSpeechService = TextToSpeechService()
        self.feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

        super.init()

        bind()
        refreshSelectedVoiceLabel()
    }
    
    private func bind() {
        personalVoiceService.authorizationStatus
            .distinctUntilChanged()
            .bind(to: personalVoiceAuthorizationStatus)
            .disposed(by: disposeBag)

        personalVoiceAuthorizationStatus
            .skip(1)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] status in
                try? self?.updatePersonalVoiceSection(for: status)
            }
            .disposed(by: disposeBag)

        textToSpeechService.isAppAudioForCallsEnabled
            .distinctUntilChanged()
            .bind(to: isAppAudioForCallsEnabled)
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
        let audioCallSetting = SettingModel(
            primaryText: NSLocalizedString("Speak during calls", comment: ""),
            secondaryText: nil
        )

        // Section 5
        let authorizationStatus = (try? personalVoiceService.authorizationStatus.value()) ?? .notDetermined
        let personalVoiceSetting = SettingModel(
            primaryText: authorizationStatus.settingsSectionTitle,
            secondaryText: nil
        )

        // Section 6
        let rateAppSetting = SettingModel(primaryText: NSLocalizedString("Rate this app", comment: ""), secondaryText: nil)
        let feedbackSetting = SettingModel(primaryText: NSLocalizedString("Send feedback", comment: ""), secondaryText: nil)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? NSLocalizedString("Unknown", comment: "")
        
        var sections = [
            SettingsSection(
                type: .speechVoice,
                footer: NSLocalizedString("Language and voice, which is used for speaking phrases. This will not affect your system language.", comment: ""),
                items: [languageSetting]
            ),
            SettingsSection(
                type: .speechRate,
                footer: NSLocalizedString("Set how fast your phrases should be spoken.", comment: ""),
                items: [rateSetting]
            ),
            SettingsSection(
                type: .speechPitch,
                footer: NSLocalizedString("Voice pitch, used for speaking phrases.", comment: ""),
                items: [pitchSetting]
            ),
            SettingsSection(
                type: .other,
                footer: NSLocalizedString("Version:", comment: "").appending(" \(appVersion)"),
                items: [rateAppSetting, feedbackSetting]
            )
        ]

        if personalVoiceService.isSupported {
            sections.insert(
                SettingsSection(type: .personalVoice,
                                footer: NSLocalizedString("You can use Personal Voice - a synthesized voice that sounds like your own in the app, only if you grant access to it.", comment: ""),
                                items: [personalVoiceSetting]),
                at: 3
            )
        }

        if textToSpeechService.isAppAudioForCallsSupported {
            sections.insert(
                SettingsSection(
                    type: .accessibility,
                    footer: NSLocalizedString("Spoken phrases will be audible during a call.", comment: ""),
                    items: [audioCallSetting]
                ),
                at: 3
            )
        }

        return sections
    }

    private func updatePersonalVoiceSection(for status: PersonalVoiceAuthorizationStatus) throws {
        var updatedSections = try sections.value()

        guard let indexToUpdate = updatedSections.firstIndex(
            where: { $0.type == .personalVoice }
        ) else {
            return
        }

        updatedSections[indexToUpdate].items = [
            SettingModel(
                primaryText: status.settingsSectionTitle,
                secondaryText: nil
            )
        ]

        sections.onNext(updatedSections)
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
    
    func requestPersonalVoiceAccess() async {
        if #available(iOS 17.0, *) {
            await personalVoiceService.requestPersonalVoiceAccess()
        }
    }
    
    func onEnterForeground() {
        if #available(iOS 17.0, *) {
            personalVoiceService.updatePersonalVoiceStatus()
        }
    }

    func setAppAudioForCalls(for shouldEnable: Bool) async -> Result<Bool, AppAudioForCallsError> {
        if #available(iOS 18.2, *) {
            let result = await textToSpeechService.setAppAudioForCalls(for: shouldEnable)

            switch result {
            case .success(let isEnabled):
                isAppAudioForCallsEnabled.onNext(isEnabled)
                
            case .failure(let error):
                print("Failed to set app audio for calls: \(error.localizedDescription)")
                isAppAudioForCallsEnabled.onNext(!shouldEnable)
            }

            return result
        } else {
            assertionFailure("setAppAudioForCalls is only available on iOS 18.2 or newer")

            return .failure(.unknown)
        }
    }

    @available(iOS 18.0, *)
    func navigateToAccessibilitySettings(for setting: AccessibilitySettings.Feature) async {
        do {
            try await AccessibilitySettings.openSettings(for: setting)
        } catch {
            print("Failed to open Accessibility Settings: \(error.localizedDescription)")
        }
    }
}

// TODO: Move

enum AppAudioForCallsError: Error {
    case systemDisabled
    case permissionDenied
    case unknown

    var canNavigateToSystemSettings: Bool {
        switch self {
        case .systemDisabled, .permissionDenied: true
        case .unknown: false
        }
    }

    var title: String {
        switch self {
        case .systemDisabled:
            NSLocalizedString("Permission required to send audio to call", comment: "")
        case .permissionDenied:
            NSLocalizedString("Permission denied", comment: "")
        case .unknown:
            NSLocalizedString("Unknown error", comment: "")
        }
    }

    var message: String {
        switch self {
        case .systemDisabled:
            NSLocalizedString("Apps are currently not allowed to add their audio to calls. Would you like to open the Settings app to enable the setting, 'Allow apps to Add Audio to Calls'?", comment: "")
        case .permissionDenied:
            NSLocalizedString("The app does not have permission to inject spoken audio. Would you like to open the Settings app to enabled permission?", comment: "")
        case .unknown:
            NSLocalizedString("An unknown error occurred. Please try again.", comment: "")
        }
    }
}


extension Result<Bool, AppAudioForCallsError> {
    var asError: AppAudioForCallsError? {
        switch self {
        case .success: nil
        case .failure(let error): error
        }
    }
}
