//
//  AVSpeechSynthesisVoice+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 18/06/2023.
//

import class AVFAudio.AVSpeechSynthesisVoice

extension AVSpeechSynthesisVoice {
    func containsSearchTerm(_ term: String) -> Bool {
        let lowercasedTerm = term.lowercased()
        let matchedIdentifier = identifier.lowercased().contains(lowercasedTerm)
        let matchedName = name.lowercased().contains(lowercasedTerm.lowercased())
        let matchedLanguage = language.voiceFullLanguage?.lowercased().contains(lowercasedTerm) == true
        
        return matchedIdentifier || matchedName || matchedLanguage
    }
}
