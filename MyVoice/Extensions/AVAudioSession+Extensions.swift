//
//  AVAudioSession+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/09/2025.
//

import AVFoundation

extension AVAudioSession.MicrophoneInjectionMode {
    var isAppAudioForCallsEnabled: Bool {
        self == .spokenAudio
    }
}
