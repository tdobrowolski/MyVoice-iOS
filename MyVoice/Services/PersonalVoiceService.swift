//
//  PersonalVoiceService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 06/10/2023.
//

import AVFoundation
import RxSwift

// TODO: Move
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

@available(iOS 17.0, *)
extension AVSpeechSynthesizer.PersonalVoiceAuthorizationStatus {
    var asDomain: PersonalVoiceAuthorizationStatus {
        switch self {
        case .notDetermined: return .notDetermined
        case .denied: return .denied
        case .unsupported: return .unsupported
        case .authorized: return .authorized
        @unknown default: return .unsupported
        }
    }
}


final class PersonalVoiceService {
    let authorizationStatus = BehaviorSubject<PersonalVoiceAuthorizationStatus>(value: .unsupported)
    
    var isSupported: Bool {
        (try? authorizationStatus.value() != .unsupported) ?? false
    }
    
    init() {
        if #available(iOS 17.0, *) {
            authorizationStatus.onNext(AVSpeechSynthesizer.personalVoiceAuthorizationStatus.asDomain)
        }
    }
    
    @available(iOS 17.0, *)
    func requestPersonalVoiceAccess() async {
        guard .authorized != AVSpeechSynthesizer.personalVoiceAuthorizationStatus else { return }
            
        let result = await AVSpeechSynthesizer.requestPersonalVoiceAuthorization()
        authorizationStatus.onNext(result.asDomain)
    }
}
