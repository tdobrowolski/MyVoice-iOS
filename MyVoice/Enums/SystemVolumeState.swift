//
//  SystemVolumeState.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 31/08/2025.
//

import AVFoundation

enum SystemVolumeState {
    case noVolume
    case lowVolume
    case mediumVolume
    case highVolume

    static func getState(from value: Double?) -> Self {
        let currentVolume = value ?? Double(AVAudioSession.sharedInstance().outputVolume)
        let noVolume = 0.0
        let lowVolume = 0.01...0.25
        let mediumVolume = 0.26...0.75

        switch currentVolume {
        case noVolume: return .noVolume
        case lowVolume: return .lowVolume
        case mediumVolume: return .mediumVolume
        default: return .highVolume
        }
    }

    var iconName: String {
        switch self {
        case .noVolume: "speaker.fill"
        case .lowVolume: "speaker.wave.1.fill"
        case .mediumVolume: "speaker.wave.2.fill"
        case .highVolume: "speaker.wave.3.fill"
        }
    }

    var simplifiedVariableValue: Double {
        switch self {
        case .noVolume: 0.0
        case .lowVolume: 0.25
        case .mediumVolume: 0.5
        case .highVolume: 1.0
        }
    }
}
