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
        reloadAvailableSpeechVoices()
        
        if #available(iOS 17.0, *) {
            Task { await requestPersonalVoiceAuth() }
        }
    }
    
    private func bind() {
        voices
            .map { $0.mapToSections }
            .bind(to: sections)
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
    
    @available(iOS 17.0, *)
    func requestPersonalVoiceAuth() async {
        guard .authorized != AVSpeechSynthesizer.personalVoiceAuthorizationStatus else { return }
            
        let authorizationResult = await AVSpeechSynthesizer.requestPersonalVoiceAuthorization()
        
        print("Personal voice result: \(authorizationResult)")
        
        switch authorizationResult {
        case .notDetermined, .denied, .unsupported: return
        case .authorized: reloadAvailableSpeechVoices()
        @unknown default: return
        }
    }
    
    @objc
    private func reloadAvailableSpeechVoices() {
        voices.onNext(AVSpeechSynthesisVoice.speechVoices())
        print("Reloaded available voices")
    }
}
