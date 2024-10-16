//
//  LaunchAppIntent.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/10/2024.
//

import AppIntents
import Shared

@available(iOS 16, *)
struct OpenApp: OpenIntent {
    static var title: LocalizedStringResource = "Open MyVoice"

    @Parameter(title: "Mode")
    var target: OpenAppModeEnum

    static var parameterSummary: some ParameterSummary {
        Summary("Open in \(\.$target)")
    }

    func perform() async throws -> some IntentResult {
        Shared.AppSignal.shared.shouldPrepareInstantTyping = true
        return .result()
    }
}

@available(iOS 16, *)
enum OpenAppModeEnum: String, AppEnum {
    case instantTyping

    static var typeDisplayRepresentation = TypeDisplayRepresentation("MyVoice launch modes")
    static var caseDisplayRepresentations = [
        OpenAppModeEnum.instantTyping: DisplayRepresentation("Instant Typing")
    ]
}
