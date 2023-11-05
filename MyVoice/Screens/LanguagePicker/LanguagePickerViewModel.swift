//
//  LanguagePickerViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 06/02/2021.
//

import AVFoundation
import Differentiator
import RxSwift

// FIXME: Personal Voice not on list after granting access (must restart app to see it)
// TODO: Improve Bottom Sheet:
// - When unspecified: Show allow access
// - When denied: Show to go to Settings anf fix permissions

protocol VoiceSelectionDelegate: AnyObject {
    func didSelectVoice()
}

final class LanguagePickerViewModel: BaseViewModel {
    weak var delegate: VoiceSelectionDelegate?
    
    let sections = BehaviorSubject<[SectionModel<String, AVSpeechSynthesisVoice>]>(value: [])
    let personalVoiceAuthorizationStatus = BehaviorSubject<PersonalVoiceAuthorizationStatus>(value: .unsupported)
    let personalVoiceService: PersonalVoiceService
    
    private let voices = BehaviorSubject<[AVSpeechSynthesisVoice]>(value: [])
    private let userDefaultsService: UserDefaultsService
    
    var selectedLanguageIdentifier: String?
    var showPersonalVoiceInfoBottomSheet: Bool {
        guard let status = try? personalVoiceAuthorizationStatus.value() else {
            return false
        }

        return !userDefaultsService.didShowPersonalVoiceInfo && status == .notDetermined
    }
    
    init(
        personalVoiceService: PersonalVoiceService,
        delegate: VoiceSelectionDelegate?
    ) {
        self.personalVoiceService = personalVoiceService
        self.userDefaultsService = UserDefaultsService()
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

        personalVoiceAuthorizationStatus
            .skip(1)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] status in
                guard status == .authorized else { return }

                self?.reloadAvailableSpeechVoices()
            }
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

    func didShowPersonalVoiceBottomSheet() {
        userDefaultsService.setPersonalVoiceInfoToShown()
    }

    @objc
    private func reloadAvailableSpeechVoices() {
        voices.onNext(AVSpeechSynthesisVoice.speechVoices())
    }
}
