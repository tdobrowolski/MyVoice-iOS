//
//  String+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 18/06/2023.
//

import Foundation

extension String {
    var voiceFullLanguage: String? {
        NSLocale(localeIdentifier: NSLocale.current.identifier)
            .displayName(forKey: NSLocale.Key.identifier, value: self)
    }
}
