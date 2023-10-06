//
//  PersonalVoiceService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 06/10/2023.
//

import AVFoundation
import RxSwift

enum PersonalVoiceAuthorizationStatus {
    /// The device is not compatibile or iOS 17+ is not installed.
    case unsupported
    
    /// User was not asked for authorization yet.
    case notDetermined
    
    /// User denied authorization request.
    case denied
    
    /// User authorized request. The app has access to Personal Voices.
    case authorized
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
