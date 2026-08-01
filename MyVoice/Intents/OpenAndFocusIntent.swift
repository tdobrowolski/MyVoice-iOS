//
//  OpenAndFocusIntent.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 01/08/2026.
//

import AppIntents

@available(iOS 18.0, *)
struct OpenAndFocusIntent: AppIntent {
    static var title: LocalizedStringResource = "Type & Speak"
    static var description = IntentDescription("Opens MyVoice with the keyboard ready.")
    static var openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        PendingActionService().setPendingAction(.focusInput)

        return .result()
    }
}
