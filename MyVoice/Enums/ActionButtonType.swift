//
//  ActionButtonType.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 31/08/2025.
//

import SwiftUI

enum ActionButtonType {
    case speak
    case display
    case save

    func getTitle(isSpeaking: Bool) -> String {
        switch self {
        case .speak:
            isSpeaking ? NSLocalizedString("Stop", comment: "Stop") : NSLocalizedString("Speak", comment: "Speak")
        case .display:
            NSLocalizedString("Display", comment: "Display")
        case .save:
            NSLocalizedString("Save", comment: "Save")
        }
    }

    func getBackgroundColor(isSpeaking: Bool) -> Color? {
        switch self {
        case .speak:
            isSpeaking ? UIColor.redLight?.asColor : UIColor.orangeLight?.asColor
        case .display, .save:
            UIColor.orangeLight?.asColor
        }
    }

    func getTintColor(isSpeaking: Bool) -> Color? {
        switch self {
        case .speak:
            isSpeaking ? UIColor.redMain?.asColor : UIColor.orangeMain?.asColor
        case .display, .save:
            UIColor.orangeMain?.asColor
        }
    }

    func getIconName(with volumeState: SystemVolumeState, isSpeaking: Bool) -> String {
        switch self {
        case .speak:
            isSpeaking ? "stop.fill" : volumeState.iconName
        case .display:
            "arrow.up.left.and.arrow.down.right"
        case .save:
            "plus.bubble.fill"
        }
    }
}
