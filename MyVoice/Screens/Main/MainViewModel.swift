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

final class MainViewModel: BaseViewModel {
    
    private let textToSpeechService: TextToSpeechService
    private let phraseDatabaseService: PhraseDatabaseService
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    var systemValueObserver: NSKeyValueObservation?
    
    let isSpeaking = BehaviorSubject<Bool>(value: false)
    let systemVolumeState = BehaviorSubject<SystemVolumeState>(value: .lowVolume)
    
    let sections = BehaviorSubject<[QuickPhraseSection]>(value: [])
    
    override init() {
        self.textToSpeechService = TextToSpeechService()
        self.phraseDatabaseService = PhraseDatabaseService()
        self.feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        super.init()
        self.bindService()
        self.getQuickPhrases()
        self.observeSystemVolumeChange()
    }
    
    private func bindService() {
        
        self.textToSpeechService.isSpeaking.subscribe(self.isSpeaking)
            .disposed(by: disposeBag)
    }
    
    func startSpeaking(_ text: String) {
        self.feedbackGenerator?.impactOccurred()
        self.textToSpeechService.startSpeaking(text: text)
    }
    
    func stopSpeaking() {
        self.textToSpeechService.stopSpeaking()
    }
    
    // TODO: Adding/removing items to sections
    
    func addQuickPhraseItem(phrase: String) {
        do {
            let selectedLanguageIdentifier = textToSpeechService.getCurrentLanguageIdentifier()
            let item = QuickPhraseModel(phrase: phrase, createdAt: Date(), prefferedLanguage: selectedLanguageIdentifier)
            self.phraseDatabaseService.insertPhrase(item)
            var sections = try self.sections.value()
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
        self.systemValueObserver = AVAudioSession.sharedInstance().observe(\.outputVolume) { [weak self] audioSession, observedChange in
            let currentVolume = Double(audioSession.outputVolume)
            print("Volume changed observed: \(currentVolume)")
            self?.systemVolumeState.onNext(SystemVolumeState.getState(from: currentVolume))
        }
    }
    
}
