//
//  AVSpeechSynthesisVoice+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 18/06/2023.
//

import class AVFAudio.AVSpeechSynthesisVoice
import RxDataSources

extension AVSpeechSynthesisVoice {
    func containsSearchTerm(_ term: String) -> Bool {
        let lowercasedTerm = term.lowercased()
        let matchedIdentifier = identifier.lowercased().contains(lowercasedTerm)
        let matchedName = name.lowercased().contains(lowercasedTerm.lowercased())
        let matchedLanguage = language.voiceFullLanguage?.lowercased().contains(lowercasedTerm) == true
        
        return matchedIdentifier || matchedName || matchedLanguage
    }
}

extension [AVSpeechSynthesisVoice] {
    var mapToSections: [SectionModel<String, AVSpeechSynthesisVoice>] {
        let allAvailableLanguages = map { $0.language }.uniqued()
        
        let sections: [SectionModel<String, AVSpeechSynthesisVoice>]
        sections = allAvailableLanguages.map { voiceAvailableLanguage in
            SectionModel(
                model: voiceAvailableLanguage.voiceFullLanguage ?? NSLocalizedString("Unknown", comment: "Unknown"),
                items: filter { $0.language == voiceAvailableLanguage }
            )
        }
        
        return sections
    }
}
