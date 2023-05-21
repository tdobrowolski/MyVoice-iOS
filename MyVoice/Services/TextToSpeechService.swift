//
//  TextToSpeechService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 18/01/2021.
//

import Foundation
import AVFoundation
import RxSwift

final class TextToSpeechService: NSObject, AVSpeechSynthesizerDelegate {
    private let speechSynthesizer: AVSpeechSynthesizer
    private let userDefaultsService: UserDefaultsService
    
    let isSpeaking = BehaviorSubject<Bool>(value: false)
    
    override init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        self.speechSynthesizer = AVSpeechSynthesizer()
        self.userDefaultsService = UserDefaultsService()

        super.init()

        self.speechSynthesizer.delegate = self
    }
        
    func startSpeaking(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        if let voice = getSelectedVoice() {
            speechUtterance.voice = voice
        }
        
        var selectedPitch = userDefaultsService.getSpeechPitch()
        selectedPitch = max(selectedPitch, 0.5)
        if selectedPitch > 2.0 {
            selectedPitch = 1.0
        }
        speechUtterance.pitchMultiplier = selectedPitch
        
        var selectedRate = userDefaultsService.getSpeechRate()
        if selectedRate < AVSpeechUtteranceMinimumSpeechRate || selectedRate > AVSpeechUtteranceMaximumSpeechRate {
            selectedRate = AVSpeechUtteranceDefaultSpeechRate
        }
        speechUtterance.rate = selectedRate
        
        print("\nSpeaking with values:\nRate: \(selectedRate)\nPitch: \(selectedPitch)\n")
        speechSynthesizer.speak(speechUtterance)
    }
    
    func stopSpeaking() {
        let speechBoundary: AVSpeechBoundary = .immediate
        speechSynthesizer.stopSpeaking(at: speechBoundary)
    }
    
    func getSelectedVoice() -> AVSpeechSynthesisVoice? {
        guard let selectedVoiceIdentifier = userDefaultsService.getSpeechVoiceIdentifier() else { return nil }

        return AVSpeechSynthesisVoice(identifier: selectedVoiceIdentifier)
    }
    
    func getCurrentLanguageIdentifier() -> String {
        let selectedVoice = getSelectedVoice()

        return selectedVoice?.language ?? AVSpeechSynthesisVoice.currentLanguageCode()
    }
    
    // MARK: Delegate methods
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.isSpeaking.onNext(true)
        print("🗣 didStart")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.isSpeaking.onNext(false)
        print("🗣 didFinish")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        self.isSpeaking.onNext(false)
        print("🗣 didCancel")
    }
}
