//
//  LaunchAppIntent.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/10/2024.
//

import AppIntents

struct LaunchAppIntent: OpenIntent {
    static var title: LocalizedStringResource = "Launch MyVoice"

    @Parameter(title: "Target")
    var target: LaunchAppEnum
}

enum LaunchAppEnum: String, AppEnum {
    case `default`
    case instantTyping

    static var typeDisplayRepresentation = TypeDisplayRepresentation("MyVoice launch modes")
    static var caseDisplayRepresentations = [
        LaunchAppEnum.default : DisplayRepresentation("Default"),
        LaunchAppEnum.instantTyping : DisplayRepresentation("Instant Typing")
    ]
}
