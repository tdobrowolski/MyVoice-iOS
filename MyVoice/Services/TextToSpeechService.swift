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
    
    let speechSynthesizer = AVSpeechSynthesizer()
    private let userDefaultsService: UserDefaultsService
    
    let isSpeaking = BehaviorSubject<Bool>(value: false)
    
    override init() {
        self.userDefaultsService = UserDefaultsService()
        super.init()
        self.speechSynthesizer.delegate = self
    }
    
    func startSpeaking(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        if let selectedVoiceIdentifier = userDefaultsService.getSpeechVoiceIdentifier(), let voice = AVSpeechSynthesisVoice(identifier: selectedVoiceIdentifier) {
            speechUtterance.voice = voice
        }
//        if let selectedPitch = userDefaultsService.getSpeechPitch() {
//            speechUtterance.pitchMultiplier = selectedPitch
//        }
//        if let selectedRate = userDefaultsService.getSpeechRate() {
//            speechUtterance.rate = selectedRate
//        }
        self.speechSynthesizer.speak(speechUtterance)
    }
    
    func stopSpeaking() {
        let speechBoundary: AVSpeechBoundary = .immediate
        self.speechSynthesizer.stopSpeaking(at: speechBoundary)
    }
    
    // MARK: Delegate methods
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.isSpeaking.onNext(true)
        print("didStart")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.isSpeaking.onNext(false)
        print("didFinish")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        self.isSpeaking.onNext(false)
        print("didCancel")
    }
}