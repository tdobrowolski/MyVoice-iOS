//
//  InstantTypingButtonControl.swift
//  InstantTypingButton
//
//  Created by Tobiasz Dobrowolski on 08/10/2024.
//

import SwiftUI
import WidgetKit

struct InstantTypingButtonControl: ControlWidget {
    private let kind = "com.infinity.MyVoiceApp.InstantTypingButton"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: kind
        ) {
            ControlWidgetButton(
                action: LaunchAppIntent()
            ) {
                Label("Instant Typing", systemImage: "waveform")
            }
        }
        .displayName("Instant Typing")
        .description("Open MyVoice in a mode that allows instant typing with a keyboard shown.")
    }
}
