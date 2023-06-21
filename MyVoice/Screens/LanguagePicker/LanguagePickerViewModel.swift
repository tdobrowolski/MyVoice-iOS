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
    weak var delegate: VoiceSelectionDelegate?
    
    let sections = BehaviorSubject<[SectionModel<String, AVSpeechSynthesisVoice>]>(value: [])
    
    private let voices = BehaviorSubject<[AVSpeechSynthesisVoice]>(value: [])
    private let userDefaultsService: UserDefaultsService
    
    var selectedLanguageIdentifier: String?
    
    init(delegate: VoiceSelectionDelegate?) {
        self.userDefaultsService = UserDefaultsService()
        self.delegate = delegate
        super.init()
        
        bind()
        selectedLanguageIdentifier = userDefaultsService.getSpeechVoiceIdentifier() ?? AVSpeechSynthesisVoice(language: nil)?.identifier
        voices.onNext(AVSpeechSynthesisVoice.speechVoices())
    }
    
    private func bind() {
        voices
            .map { $0.mapToSections }
            .bind(to: sections)
            .disposed(by: disposeBag)
    }
    
    func selectVoice(for identifier: String) {
        userDefaultsService.setSpeechVoice(for: identifier)
        delegate?.didSelectVoice()
    }
    
    /// Find IndexPath of element in UITableView based on its identifier
    func firstIndexPath(for identifier: String) -> IndexPath? {
        guard let sections = try? sections.value(),
              let section = sections.firstIndex(where: { $0.items.contains { $0.identifier == identifier } }),
              let row = sections[section].items.firstIndex(where: { $0.identifier == identifier }) else {
            return nil
        }
        
        return .init(row: row, section: section)
    }
    
    func didEnterSearchTerm(_ searchTerm: String) {
        guard searchTerm.isEmpty == false else { return voices.onNext(AVSpeechSynthesisVoice.speechVoices()) }
        
        let currentVoices = (try? voices.value()) ?? []
        let filteredVoices = currentVoices.filter { $0.containsSearchTerm(searchTerm) }
        voices.onNext(filteredVoices)
    }
}

// TODO: Move

extension [AVSpeechSynthesisVoice] {
    var mapToSections: [SectionModel<String, AVSpeechSynthesisVoice>] {
        let allAvailableLanguages = map { $0.language }.uniqued()
        
        let sections: [SectionModel<String, AVSpeechSynthesisVoice>]
        sections = allAvailableLanguages.map { voiceAvailableLanguage in
            SectionModel(
                model: voiceAvailableLanguage.voiceFullLanguage ?? NSLocalizedString("Unknown", comment: "Unknown"),
                items: filter { $0.language == voiceAvailableLanguage }
            )
        }
        
        return sections
    }
}
