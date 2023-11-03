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
            return NSLocalizedString("Access to Personal Voice was denied. You can change this setting, by granting access again in the Settings app.", comment: "")

        case .authorized:
            return NSLocalizedString("Access to Personal Voice was granted. You can now select configured Personal Voices from the voice picker list.", comment: "")
        }
    }
}
