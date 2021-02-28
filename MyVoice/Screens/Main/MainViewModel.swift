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
    
    enum SystemVolumeState {
        case noVolume
        case lowVolume
        case mediumVolume
        case highVolume
    }
    
    private let textToSpeechService: TextToSpeechService
    private let phraseDatabaseService: PhraseDatabaseService
    
    var systemValueObserver: NSKeyValueObservation?
    
    let isSpeaking = BehaviorSubject<Bool>(value: false)
    let systemVolumeState = BehaviorSubject<SystemVolumeState>(value: .lowVolume)
    
    let sections = BehaviorSubject<[QuickPhraseSection]>(value: [])
    
    override init() {
        self.textToSpeechService = TextToSpeechService()
        self.phraseDatabaseService = PhraseDatabaseService()
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
            let noVolume = 0.0
            let lowVolume = 0.01...0.25
            let mediumVolume = 0.26...0.75
//            let highVolume = 0.76...1.0
            print("Volume changed observed: \(currentVolume)")
            if currentVolume == noVolume {
                self?.systemVolumeState.onNext(.noVolume)
            } else if lowVolume.contains(currentVolume) {
                self?.systemVolumeState.onNext(.lowVolume)
            } else if mediumVolume.contains(currentVolume) {
                self?.systemVolumeState.onNext(.mediumVolume)
            } else {
                self?.systemVolumeState.onNext(.highVolume)
            }
        }
    }
    
}
