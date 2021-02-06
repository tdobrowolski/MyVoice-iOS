//
//  LanguagePickerViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 06/02/2021.
//

import AVFoundation
import RxSwift

final class LanguagePickerViewModel: BaseViewModel {
    
    let availableLanguages = BehaviorSubject<[AVSpeechSynthesisVoice]>(value: [])
    
    override init() {
        super.init()
        self.availableLanguages.onNext(AVSpeechSynthesisVoice.speechVoices())
    }
}


