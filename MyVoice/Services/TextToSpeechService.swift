//
//  TextToSpeechService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 18/01/2021.
//

import AVFoundation
import RxSwift

final class TextToSpeechService: NSObject, AVSpeechSynthesizerDelegate {
    private let speechSynthesizer: AVSpeechSynthesizer
    private let userDefaultsService: UserDefaultsService
    
    let isSpeaking = BehaviorSubject<Bool>(value: false)

    // TODO: Debug if works correctly after mode change
    override init() {
        self.speechSynthesizer = AVSpeechSynthesizer()
        self.userDefaultsService = UserDefaultsService()

        super.init()

        setupAVAudioSession() // TODO: Check if works after super.init()

        speechSynthesizer.delegate = self
    }

    private func setupAVAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playAndRecord,
                mode: .voicePrompt,
                options: [
                    .defaultToSpeaker, // TODO: Check if works with telephone
                    .duckOthers, // TODO: Check if played audio has low volume when speaking
                    .mixWithOthers // TODO: Check if can talk with music with this optionss and without it too
                ]
            )

            // TODO: Check if needed for telephone
//            try? AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
        } catch {
            print("🔴 Error: \(error.localizedDescription)")
        }
    }

    func startSpeaking(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = getSelectedVoice()
        
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
