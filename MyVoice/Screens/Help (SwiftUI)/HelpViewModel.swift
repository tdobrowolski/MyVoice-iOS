//
//  HelpViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 14/03/2021.
//

import Foundation
import SwiftUI

final class HelpViewModel: BaseViewModel, ObservableObject {
    @Published var types: [HelpContentType]
    @Published var onDone: () -> Void

    init(
        supportsPersonalVoice: Bool,
        onDone: @escaping () -> Void
    ) {
        types = supportsPersonalVoice ? HelpContentType.allCases : HelpContentType.allCasesWithoutPersonalVoice
        self.onDone = onDone
    }

    func getVoiceOverHelpURL(prefferedLanguages: [String]) -> URL? {
        if let selectedLanguage = prefferedLanguages.first {
            switch selectedLanguage {
            case "pl":
                return URL(string: "https://support.apple.com/pl-pl/HT202362")
                
            default:
                return URL(string: "https://support.apple.com/en-gb/HT202362")
            }
        } else {
            return URL(string: "https://support.apple.com/en-gb/HT202362")
        }
    }

    func didTapDone() {
        onDone()
    }
}
