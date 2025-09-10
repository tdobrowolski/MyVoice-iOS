//
//  MainViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 18/01/2021.
//

import Foundation
import RxSwift
import RxDataSources
import AVKit

final class MainViewModel: BaseViewModel, ObservableObject {
    private let phraseDatabaseService: PhraseDatabaseService
    private var feedbackGenerator: UIImpactFeedbackGenerator
    private var notificationFeedbackGenerator: UINotificationFeedbackGenerator
    
    var systemValueObserver: NSKeyValueObservation?

    // TextToSpeechService & PersonalVoiceService is needed in this ViewModel only to pass to other, child views/modals.
    // This is dictated by wrong architecture pick at the start of the development and should be fixed in the future.
    // CompositionRoot should be used.

    let textToSpeechService: TextToSpeechService
    let personalVoiceService: PersonalVoiceService

    let isSpeaking = BehaviorSubject<Bool>(value: false)
    let systemVolumeState = BehaviorSubject<SystemVolumeState>(value: .mediumVolume)

    let sections = BehaviorSubject<[QuickPhraseSection]>(value: [])
    
    override init() {
        self.textToSpeechService = TextToSpeechService()
        self.phraseDatabaseService = PhraseDatabaseService()
        self.feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        self.notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        self.personalVoiceService = PersonalVoiceService()

        super.init()

        bindService()
        getQuickPhrases()
        observeSystemVolumeChange()
    }
    
    private func bindService() {
        textToSpeechService.isSpeaking.subscribe(self.isSpeaking)
            .disposed(by: disposeBag)
    }
    
    func startSpeaking(_ text: String) {
        impactUserWithFeedback()
        textToSpeechService.startSpeaking(text: text)
    }
    
    func stopSpeaking() { textToSpeechService.stopSpeaking() }
    
    func impactUserWithFeedback() { feedbackGenerator.impactOccurred() }
    
    func warnUserWithFeedback() {
        notificationFeedbackGenerator.notificationOccurred(.error)
    }
    
    // TODO: Adding / removing items to sections

    func addQuickPhraseItem(phrase: String) {
        do {
            let selectedLanguageIdentifier = textToSpeechService.getCurrentLanguageIdentifier()
            let item = QuickPhraseModel(
                phrase: phrase,
                createdAt: Date(),
                prefferedLanguage: selectedLanguageIdentifier
            )
            phraseDatabaseService.insertPhrase(item)

            var sections = try sections.value()
            sections[0].items.insert(item, at: 0)
            self.sections.onNext(sections)
        } catch {
            logError(with: error)
        }
    }
    
    func removeQuickPhraseItem(at row: Int) {
        do {
            var sections = try self.sections.value()
            let item = sections[0].items[row]
            self.phraseDatabaseService.removePhrase(item)
            sections[0].items.remove(at: row)
            self.sections.onNext(sections)
        } catch {
            logError(with: error)
        }
    }
    
    private func getQuickPhrases() {
        let sections = [QuickPhraseSection(items: self.phraseDatabaseService.fetchAllPhrases())]
        self.sections.onNext(sections)
    }
    
    // MARK: Listen to system volume change
    
    private func observeSystemVolumeChange() {
        systemValueObserver = AVAudioSession.sharedInstance().observe(\.outputVolume) { [weak self] audioSession, observedChange in
            let currentVolume = Double(audioSession.outputVolume)
            print("Volume changed observed: \(currentVolume)")
            self?.systemVolumeState.onNext(SystemVolumeState.getState(from: currentVolume))
        }
    }
}
