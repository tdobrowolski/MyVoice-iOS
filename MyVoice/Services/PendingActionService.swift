//
//  PendingActionService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 01/08/2026.
//

import Foundation

final class PendingActionService {
    static let appGroupIdentifier = "group.com.infinity.MyVoiceApp"

    enum PendingAction: String {
        case focusInput
    }

    private enum Keys: String {
        case pendingAction = "PendingAction"
    }

    private let defaults = UserDefaults(suiteName: PendingActionService.appGroupIdentifier)

    func setPendingAction(_ action: PendingAction) {
        defaults?.set(action.rawValue, forKey: Keys.pendingAction.rawValue)
    }

    func consumePendingAction() -> PendingAction? {
        guard let rawValue = defaults?.string(forKey: Keys.pendingAction.rawValue) else { return nil }

        defaults?.removeObject(forKey: Keys.pendingAction.rawValue)

        return PendingAction(rawValue: rawValue)
    }
}
