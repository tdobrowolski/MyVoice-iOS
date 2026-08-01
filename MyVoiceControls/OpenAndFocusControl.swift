//
//  OpenAndFocusControl.swift
//  MyVoiceControls
//
//  Created by Tobiasz Dobrowolski on 01/08/2026.
//

import SwiftUI
import WidgetKit

struct OpenAndFocusControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "com.infinity.MyVoiceApp.Controls.OpenAndFocus") {
            ControlWidgetButton(action: OpenAndFocusIntent()) {
                Label("Type & Speak", systemImage: "text.bubble.fill")
            }
        }
        .displayName("Type & Speak")
        .description("Opens MyVoice with the keyboard ready.")
    }
}
