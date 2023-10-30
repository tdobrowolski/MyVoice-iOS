//
//  PersonalVoiceService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 06/10/2023.
//

import AVFoundation
import RxSwift

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
