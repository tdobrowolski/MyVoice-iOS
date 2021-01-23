//
//  MainViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 18/01/2021.
//

import Foundation
import RxSwift

final class MainViewModel: BaseViewModel {
    
    private let textToSpeechService: TextToSpeechService
    
    let isSpeaking = BehaviorSubject<Bool>(value: false)
    
    let quickPhraseItems = BehaviorSubject<[QuickPhraseModel]>(value: [])
    
    override init() {
        self.textToSpeechService = TextToSpeechService()
        super.init()
        self.bindService()
        self.quickPhraseItems.onNext(self.getQuickPhrasesForDebug())
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
    
    /// Generates quick phrases for testing purposes
    private func getQuickPhrasesForDebug() -> [QuickPhraseModel] {
        let language = Locale.preferredLanguages[0]
        let date = Date()
        let quickPhrase1 = QuickPhraseModel(phrase: "Where is the nearest train station? I can't find it on the map.", createdAt: date, prefferedLanguage: language)
        let quickPhrase2 = QuickPhraseModel(phrase: "Sorry, do you know where can I buy ticket for this train?", createdAt: date, prefferedLanguage: language)
        let quickPhrase3 = QuickPhraseModel(phrase: "I need one train ticket to Warsaw for today.", createdAt: date, prefferedLanguage: language)
        let quickPhrase4 = QuickPhraseModel(phrase: "I want a refund for my ticket. The train is runnig late.", createdAt: date, prefferedLanguage: language)
        let quickPhrase5 = QuickPhraseModel(phrase: "Sorry, do you know where is the bathroom?", createdAt: date, prefferedLanguage: language)
        let quickPhrase6 = QuickPhraseModel(phrase: "I lost my wallet. Can you help me find it?", createdAt: date, prefferedLanguage: language)
        let quickPhrase7 = QuickPhraseModel(phrase: "I'm still waiting for my Android TV 11 update.", createdAt: date, prefferedLanguage: language)
        return [quickPhrase1, quickPhrase2, quickPhrase3, quickPhrase4, quickPhrase5, quickPhrase6, quickPhrase7]
    }
}
