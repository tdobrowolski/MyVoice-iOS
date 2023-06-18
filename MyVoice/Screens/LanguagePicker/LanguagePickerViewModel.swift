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
    
    init(delegate: VoiceSelectionDelegate?) {
        self.userDefaultsService = UserDefaultsService()
        self.delegate = delegate
        super.init()
        
        self.setupSectionsWithVoices()
    }
    
    func getIndexPathForCurrentVoice() -> IndexPath {
        if let currentVoiceIdentifier = userDefaultsService.getSpeechVoiceIdentifier(), // User has voice saved in UserDefaults
           let indexPathToSelect = firstIndexPath(for: currentVoiceIdentifier) {
            
            return indexPathToSelect
        } else if let defaultVoice = AVSpeechSynthesisVoice(language: nil), // User has no voice saved in UserDefaults
                  let defaultVoiceIndexPathToSelect = firstIndexPath(for: defaultVoice.identifier) {
            userDefaultsService.setSpeechVoice(for: defaultVoice.identifier)
            
            return defaultVoiceIndexPathToSelect
        } else {
            return .init(row: 0, section: 0)
        }
    }
    
    func selectVoiceForIndexPath(_ indexPath: IndexPath) {
        guard let voices = try? voices.value() else { return }
        
        let selectedVoice = voices[indexPath.section].items[indexPath.row]
        userDefaultsService.setSpeechVoice(for: selectedVoice.identifier)
        delegate?.didSelectVoice()
    }
    
    private func setupSectionsWithVoices() {
        let availableSpeechVoices = AVSpeechSynthesisVoice.speechVoices()
        let allAvailableLanguages = availableSpeechVoices.map { $0.language }.uniqued()
        
        let sections: [SectionModel<String, AVSpeechSynthesisVoice>]
        sections = allAvailableLanguages.map { voiceAvailableLanguage in
            SectionModel(
                model: voiceAvailableLanguage.voiceFullLanguage ?? NSLocalizedString("Unknown", comment: "Unknown"),
                items: availableSpeechVoices.filter { $0.language == voiceAvailableLanguage }
            )
        }
        
        voices.onNext(sections)
    }
    
    private func firstIndexPath(for identifier: String) -> IndexPath? {
        guard let voices = try? voices.value(),
              let section = voices.firstIndex(where: { $0.items.contains { $0.identifier == identifier } }),
              let row = voices[section].items.firstIndex(where: { $0.identifier == identifier }) else {
            return nil
        }
        
        return .init(row: row, section: section)
    }
}
