//
//  SpeakButtonViewState.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 31/08/2025.
//

import SwiftUI

// This allows to connect RxSwift, SwiftUI and UIKit together
// The right choice is to store this type of data in ViewModel
// This should be achieved by rewriting the MainViewController with SwiftUI + Combine in the future
class SpeakButtonViewState: ObservableObject {
    @Published var isSpeaking = false
    @Published var systemVolumeState: SystemVolumeState = .mediumVolume
}
