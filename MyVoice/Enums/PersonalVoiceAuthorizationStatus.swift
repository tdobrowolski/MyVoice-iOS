//
//  PersonalVoiceAuthorizationStatus.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 30/10/2023.
//

import Foundation

enum PersonalVoiceAuthorizationStatus {
    /// The device is not compatibile or iOS 17+ is not installed.
    case unsupported

    /// User was not asked for authorization yet.
    case notDetermined

    /// User denied authorization request.
    case denied

    /// User authorized request. The app has access to Personal Voices.
    case authorized

    var title: String {
        switch self {
        case .unsupported: return NSLocalizedString("Personal Voice not supported", comment: "")
        case .notDetermined: return NSLocalizedString("Access not determined", comment: "")
        case .denied: return NSLocalizedString("Access denied", comment: "")
        case .authorized: return NSLocalizedString("Access granted", comment: "")
        }
    }

    var settingsSectionTitle: String {
        switch self {
        case .unsupported: return NSLocalizedString("Personal Voice not supported", comment: "")
        case .notDetermined: return NSLocalizedString("Grant Personal Voice access", comment: "")
        case .denied: return NSLocalizedString("Personal Voice access denied", comment: "")
        case .authorized: return NSLocalizedString("Personal Voice access granted", comment: "")
        }
    }

    var settingsAlertMessage: String {
        switch self {
        case .unsupported:
            return NSLocalizedString("This device doesn't support Personal Voice.", comment: "")

        case .notDetermined:
            return NSLocalizedString("Access to Personal Voice was not yet determined.", comment: "")

        case .denied:
            return NSLocalizedString("Access to Personal Voice was denied by the user or it's blocked from the Settings app. Make sure to grant access to third-party apps from the Settings app (Accessibility > Personal Voice), then allow use from MyVoice app settings.", comment: "")

        case .authorized:
            return NSLocalizedString("Access to Personal Voice was granted. You can now select configured Personal Voices from the voice picker list.", comment: "")
        }
    }

    var accessDeniedOrNotDetermined: Bool {
        switch self {
        case .notDetermined, .denied: return true
        default: return false
        }
    }

    @available(iOS 17.0, *)
    var toPersonalVoiceBottomSheetType: PersonalVoiceBottomSheetViewModel.AccessType {
        switch self {
        case .notDetermined: 
            return .accessNotSpecified

        case .denied: 
            return .accessDenied

        default:
            assertionFailure("Tried to show Personal Voice Bottom Sheet for wrong access.")
            return .accessNotSpecified
        }
    }
}
