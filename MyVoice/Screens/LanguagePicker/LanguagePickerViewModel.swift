//
//  LanguagePickerViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 06/02/2021.
//

import AVFoundation
import RxSwift

protocol VoiceSelectedDelegate: AnyObject {
    func userSelectedVoice()
}

final class LanguagePickerViewModel: BaseViewModel {
    private let userDefaultsService: UserDefaultsService
    weak var delegate: VoiceSelectedDelegate?
    
    let availableVoices = BehaviorSubject<[AVSpeechSynthesisVoice]>(value: [])
    
    init(delegate: VoiceSelectedDelegate?) {
        self.userDefaultsService = UserDefaultsService()
        self.delegate = delegate
        self.availableVoices.onNext(AVSpeechSynthesisVoice.speechVoices())
    }
    
    func getIndexForCurrentVoice() -> Int {
        guard let languages = try? self.availableVoices.value() else { return 0 }

        if let currentVoiceIdentifier = userDefaultsService.getSpeechVoiceIdentifier(),
           let indexToSelect = languages.firstIndex(where: { $0.identifier == currentVoiceIdentifier }) {
            // User has voice saved in UserDefaults

            return indexToSelect
        } else if let defaultVoice = AVSpeechSynthesisVoice(language: nil),
                  let defaultVoiceIndexToSelect = languages.firstIndex(where: { $0.identifier == defaultVoice.identifier }) {
            // User has no voice saved in UserDefaults
            userDefaultsService.setSpeechVoice(for: defaultVoice.identifier)

            return defaultVoiceIndexToSelect
        } else {
            return 0
        }
    }
    
    func selectVoiceForIndexPath(_ indexPath: IndexPath) {
        guard let voices = try? self.availableVoices.value() else { return }
        
        let selectedVoice = voices[indexPath.row]
        userDefaultsService.setSpeechVoice(for: selectedVoice.identifier)
        delegate?.userSelectedVoice()
    }
}


