//
//  LanguagePickerViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 06/02/2021.
//

import AVFoundation
import Differentiator
import RxSwift

protocol VoiceSelectionDelegate: AnyObject {
    func didSelectVoice()
}

final class LanguagePickerViewModel: BaseViewModel {
    private let userDefaultsService: UserDefaultsService
    weak var delegate: VoiceSelectionDelegate?
    
    // FIXME: Needs two data sources, search elements indexes dont match
    let voices = BehaviorSubject<[SectionModel<String, AVSpeechSynthesisVoice>]>(value: [])
    var selectedLanguageIdentifier: String?
    
    init(delegate: VoiceSelectionDelegate?) {
        self.userDefaultsService = UserDefaultsService()
        self.delegate = delegate
        super.init()
        
        selectedLanguageIdentifier = userDefaultsService.getSpeechVoiceIdentifier() ?? AVSpeechSynthesisVoice(language: nil)?.identifier
        voices.onNext(getSectionsWithVoices())
    }
    
//    func getIndexPathForCurrentVoice() -> IndexPath {
//        if let currentVoiceIdentifier = userDefaultsService.getSpeechVoiceIdentifier(), // User has voice saved in UserDefaults
//           let indexPathToSelect = firstIndexPath(for: currentVoiceIdentifier) {
//
//            return indexPathToSelect
//        } else if let defaultVoice = AVSpeechSynthesisVoice(language: nil), // User has no voice saved in UserDefaults
//                  let defaultVoiceIndexPathToSelect = firstIndexPath(for: defaultVoice.identifier) {
//            userDefaultsService.setSpeechVoice(for: defaultVoice.identifier)
//
//            return defaultVoiceIndexPathToSelect
//        } else {
//            return .init(row: 0, section: 0)
//        }
//    }
    
    func selectVoice(for identifier: String) {
        userDefaultsService.setSpeechVoice(for: identifier)
        delegate?.didSelectVoice()
    }
    
    func getSectionsWithVoices() -> [SectionModel<String, AVSpeechSynthesisVoice>] {
        let availableSpeechVoices = AVSpeechSynthesisVoice.speechVoices()
        let allAvailableLanguages = availableSpeechVoices.map { $0.language }.uniqued()
        
        let sections: [SectionModel<String, AVSpeechSynthesisVoice>]
        sections = allAvailableLanguages.map { voiceAvailableLanguage in
            SectionModel(
                model: voiceAvailableLanguage.voiceFullLanguage ?? NSLocalizedString("Unknown", comment: "Unknown"),
                items: availableSpeechVoices.filter { $0.language == voiceAvailableLanguage }
            )
        }
        
        return sections
    }
    
    func firstIndexPath(for identifier: String) -> IndexPath? {
        guard let voices = try? voices.value(),
              let section = voices.firstIndex(where: { $0.items.contains { $0.identifier == identifier } }),
              let row = voices[section].items.firstIndex(where: { $0.identifier == identifier }) else {
            return nil
        }
        
        return .init(row: row, section: section)
    }
}
