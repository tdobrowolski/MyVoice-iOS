//
//  InstantTypingButtonControl.swift
//  InstantTypingButton
//
//  Created by Tobiasz Dobrowolski on 08/10/2024.
//

import SwiftUI
import WidgetKit

@available(iOS 18, *)
struct InstantTypingButtonControl: ControlWidget {
    let kind = "com.infinity.MyVoiceApp.InstantTypingButton"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: kind
        ) {
            ControlWidgetButton(
                action: OpenApp()
            ) {
                Label("Instant Typing", systemImage: "waveform")
            }
        }
        .displayName("Instant Typing")
    }
}
