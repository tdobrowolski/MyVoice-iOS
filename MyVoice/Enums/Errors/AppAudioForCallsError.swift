//
//  AppAudioForCallsError.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/09/2025.
//

import Foundation

enum AppAudioForCallsError: Error {
    case systemDisabled
    case permissionDenied
    case unknown

    var canNavigateToSystemSettings: Bool {
        switch self {
        case .systemDisabled, .permissionDenied: true
        case .unknown: false
        }
    }

    var title: String {
        switch self {
        case .systemDisabled:
            NSLocalizedString("Permission required to send audio to call", comment: "")
        case .permissionDenied:
            NSLocalizedString("Permission denied", comment: "")
        case .unknown:
            NSLocalizedString("Unknown error", comment: "")
        }
    }

    var message: String {
        switch self {
        case .systemDisabled:
            NSLocalizedString("Apps are currently not allowed to add their audio to calls. Would you like to open the Settings app to enable the setting, 'Allow apps to Add Audio to Calls'?", comment: "")
        case .permissionDenied:
            NSLocalizedString("The app does not have permission to inject spoken audio. Would you like to open the Settings app to enabled permission?", comment: "")
        case .unknown:
            NSLocalizedString("An unknown error occurred. Please try again.", comment: "")
        }
    }
}


extension Result<Bool, AppAudioForCallsError> {
    var asError: AppAudioForCallsError? {
        switch self {
        case .success: nil
        case .failure(let error): error
        }
    }
}
