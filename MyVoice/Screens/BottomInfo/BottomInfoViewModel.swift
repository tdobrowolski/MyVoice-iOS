//
//  BottomInfoViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 03/10/2023.
//

import Foundation

final class BottomInfoViewModel: BaseViewModel {
    private let personalVoiceService: PersonalVoiceService
    
    init(personalVoiceService: PersonalVoiceService) {
        self.personalVoiceService = personalVoiceService
    }
    
    @available(iOS 17.0, *)
    func didTapGrantAccess() async {
        let _ = await personalVoiceService.requestPersonalVoiceAccess()
    }
}
