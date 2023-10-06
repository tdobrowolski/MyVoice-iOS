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
    let personalVoiceAuthorizationStatus = BehaviorSubject<PersonalVoiceAuthorizationStatus>(value: .unsupported)
    
    private let voices = BehaviorSubject<[AVSpeechSynthesisVoice]>(value: [])
    private let userDefaultsService: UserDefaultsService
    private let personalVoiceService: PersonalVoiceService
    
    var selectedLanguageIdentifier: String?
    var showPersonalVoiceInfoBottomSheet: Bool {
        if #available(iOS 17.0, *) {
            guard let status = try? personalVoiceAuthorizationStatus.value() else { return false }
            
            return userDefaultsService.didShowPersonalVoiceInfo == false && status == .notDetermined
        } else {
            return false
        }
    }
    
    init(delegate: VoiceSelectionDelegate?) {
        self.userDefaultsService = UserDefaultsService()
        self.personalVoiceService = PersonalVoiceService()
        self.delegate = delegate
        super.init()
        
        bind()
        selectedLanguageIdentifier = userDefaultsService.getSpeechVoiceIdentifier() ?? AVSpeechSynthesisVoice(language: nil)?.identifier
        reloadAvailableSpeechVoices()
    }
    
    private func bind() {
        voices
            .map { $0.mapToSections }
            .bind(to: sections)
            .disposed(by: disposeBag)
        
        personalVoiceService.authorizationStatus
            .bind(to: personalVoiceAuthorizationStatus)
            .disposed(by: disposeBag)
        
        if #available(iOS 17.0, *) {
            NotificationCenter.default
                .addObserver(
                    self,
                    selector: #selector(reloadAvailableSpeechVoices),
                    name: AVSpeechSynthesizer.availableVoicesDidChangeNotification,
                    object: nil
                )
        }
    }
    
    func firstIndexPath(for identifier: String) -> IndexPath? {
        guard let sections = try? sections.value(),
              let section = sections.firstIndex(where: { $0.items.contains { $0.identifier == identifier } }),
              let row = sections[section].items.firstIndex(where: { $0.identifier == identifier }) else {
            return nil
        }
        
        return .init(row: row, section: section)
    }
    
    func didEnterSearchTerm(_ searchTerm: String) {
        let availableVoices = AVSpeechSynthesisVoice.speechVoices()
        
        guard searchTerm.isEmpty == false else { return voices.onNext(availableVoices) }
        
        let filteredVoices = availableVoices.filter { $0.containsSearchTerm(searchTerm) }
        voices.onNext(filteredVoices)
    }
    
    func selectVoice(for identifier: String) {
        userDefaultsService.setSpeechVoice(for: identifier)
        delegate?.didSelectVoice()
    }
    
    @objc
    private func reloadAvailableSpeechVoices() {
        voices.onNext(AVSpeechSynthesisVoice.speechVoices())
    }
}
