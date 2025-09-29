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
            true
        } else {
            false
        }
    }

    var systemValueObserver: NSKeyValueObservation?

    let isSpeaking = BehaviorSubject<Bool>(value: false)
    let isAppAudioForCallsEnabled = BehaviorSubject<Bool>(value: false)
    let systemVolumeState = BehaviorSubject<SystemVolumeState>(value: .mediumVolume)

    private let speechSynthesizer: AVSpeechSynthesizer
    private let userDefaultsService: UserDefaultsService

    init(userDefaultsService: UserDefaultsService) {
        speechSynthesizer = AVSpeechSynthesizer()
        self.userDefaultsService = userDefaultsService

        super.init()

        Task {
            await setupAVAudioSession()
            if #available(iOS 18.2, *) {
                await observeMediaServiceResets()
            }
        }

        observeSystemVolumeChange()

        speechSynthesizer.delegate = self
    }

    // MARK: Initial Setup

    private func setupAVAudioSession() async {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .voicePrompt,
                options: [.duckOthers]
            )

            if #available(iOS 18.2, *) {
                let _ = await setAppAudioForCalls(for: userDefaultsService.isAppAudioForCallsEnabled())
            }

            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("🔴 AVAudioSession error: \(error.localizedDescription)")
        }
    }

    func observeSystemVolumeChange() {
        systemValueObserver = AVAudioSession.sharedInstance().observe(\.outputVolume) { [weak self] audioSession, observedChange in
            let currentVolume = Double(audioSession.outputVolume)
            print("Volume changed observed: \(currentVolume)")
            self?.systemVolumeState.onNext(SystemVolumeState.getState(from: currentVolume))
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
            userDefaultsService.setAppAudioForCalls(enabled: false)

            return .success(false)
        }

        let permission = AVAudioApplication.shared.microphoneInjectionPermission
        switch permission {
        case .serviceDisabled:
            return .failure(.systemDisabled)

        case .undetermined:
            if await AVAudioApplication.requestMicrophoneInjectionPermission() == .granted {
                setMicrophoneInjection(for: .spokenAudio)
            } else {
                return .failure(.permissionDenied)
            }

        case .granted:
            setMicrophoneInjection(for: .spokenAudio)

        case .denied:
            return .failure(.permissionDenied)

        @unknown default:
            assertionFailure("Unknown AVAudioApplication.MicrophoneInjectionPermission case")
        }

        if (try? isAppAudioForCallsEnabled.value()) == true {
            userDefaultsService.setAppAudioForCalls(enabled: true)

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
