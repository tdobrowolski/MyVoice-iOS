//
//  TextToSpeechService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 18/01/2021.
//

import AVFoundation
import RxSwift

final class TextToSpeechService: NSObject {
    var isAppAudioForCallsSupported: Bool {
        if #available(iOS 18.2, *) {
            AVAudioSession.sharedInstance().isMicrophoneInjectionAvailable
        } else {
            false
        }
    }

    let isSpeaking = BehaviorSubject<Bool>(value: false)
    let isAppAudioForCallsEnabled = BehaviorSubject<Bool>(value: false)

    private let speechSynthesizer: AVSpeechSynthesizer
    private let userDefaultsService: UserDefaultsService

    override init() {
        speechSynthesizer = AVSpeechSynthesizer()
        userDefaultsService = UserDefaultsService()

        super.init()

        Task { await setupAVAudioSession() }

        speechSynthesizer.delegate = self
    }

    // MARK: Initial Setup

    private func setupAVAudioSession() async {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .voicePrompt,
                options: [
//                                        .defaultToSpeaker, // TODO: Check if works with telephone
                    .duckOthers, // TODO: Check if played audio has low volume when speaking
                    .mixWithOthers // TODO: Check if can talk with music with this optionss and without it too
                ]
            )

            if #available(iOS 18.2, *) {
                let _ = await setAppAudioForCalls(for: userDefaultsService.isAppAudioForCallsEnabled())
                await observeMediaServiceResets()
            }

            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("🔴 AVAudioSession error: \(error.localizedDescription)")
        }
    }

    // MARK: Speaking

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

    // MARK: Voice Selection

    func getSelectedVoice() -> AVSpeechSynthesisVoice? {
        guard let selectedVoiceIdentifier = userDefaultsService.getSpeechVoiceIdentifier() else { return nil }

        return AVSpeechSynthesisVoice(identifier: selectedVoiceIdentifier)
    }

    func getCurrentLanguageIdentifier() -> String {
        let selectedVoice = getSelectedVoice()

        return selectedVoice?.language ?? AVSpeechSynthesisVoice.currentLanguageCode()
    }

    // MARK: App Audio For Calls

    @available(iOS 18.2, *)
    func setAppAudioForCalls(for isEnabled: Bool) async -> Result<Bool, AppAudioForCallsError> {
        guard isEnabled else {
            setMicrophoneInjection(for: .none)
            return .success(false)
        }

        let permission = AVAudioApplication.shared.microphoneInjectionPermission
        switch permission {
        case .serviceDisabled:
            return .failure(.systemDisabled)

        case .undetermined:
            if await AVAudioApplication.requestMicrophoneInjectionPermission() == .granted {
                setMicrophoneInjection(for: .spokenAudio)
            }

        case .granted:
            setMicrophoneInjection(for: .spokenAudio)

        case .denied:
            return .failure(.permissionDenied)

        @unknown default:
            assertionFailure("Unknown AVAudioApplication.MicrophoneInjectionPermission case")
        }


        if (try? isAppAudioForCallsEnabled.value()) == true {
            return .success(true)
        } else {
            return .failure(.unknown)
        }
    }

    @available(iOS 18.2, *)
    private func setMicrophoneInjection(for mode: AVAudioSession.MicrophoneInjectionMode) {
        do {
            try AVAudioSession.sharedInstance().setPreferredMicrophoneInjectionMode(mode)
            isAppAudioForCallsEnabled.onNext(mode.isAppAudioForCallsEnabled)
        } catch {
            isAppAudioForCallsEnabled.onNext(false)
            print("🔴 AVAudioSession MicrophoneInjection error: \(error.localizedDescription)")
        }
    }

    @available(iOS 18.2, *)
    private func observeMediaServiceResets() async {
        for await notification in NotificationCenter.default.notifications(named: AVAudioSession.mediaServicesWereResetNotification) {
            print("The system reset media services. \(notification.name) - \(String(describing: notification.userInfo))")
            if (try? isAppAudioForCallsEnabled.value()) == true {
                setMicrophoneInjection(for: .spokenAudio)
            }
        }
    }
}

extension TextToSpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking.onNext(true)
        print("🗣 didStart")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking.onNext(false)
        print("🗣 didFinish")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking.onNext(false)
        print("🗣 didCancel")
    }
}

// TODO: Move

extension AVAudioSession.MicrophoneInjectionMode {
    var isAppAudioForCallsEnabled: Bool {
        self == .spokenAudio
    }
}
