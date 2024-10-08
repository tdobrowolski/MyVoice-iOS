//
//  HelpContentType.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/10/2023.
//

import Foundation
import UIKit.UIColor

enum HelpContentType: String, CaseIterable, Identifiable {
    case speakPhrases
    case customizeSpeak
    case changeVoice
    case downloadVoice
    case personalVoice
    case quickAccess
    
    var id: String { rawValue }
    
    var primaryTitle: String {
        switch self {
        case .speakPhrases:
            return NSLocalizedString("How to make my phrases be spoken out loud?", comment: "")
            
        case .customizeSpeak:
            return NSLocalizedString("How to customize the way my phrases are spoken?", comment: "")
            
        case .changeVoice:
            return NSLocalizedString("How to change speaking voice and its language?", comment: "")
            
        case .downloadVoice:
            return NSLocalizedString("How to download more voices?", comment: "")
            
        case .personalVoice:
            return NSLocalizedString("How to use Personal Voice?", comment: "")
            
        case .quickAccess:
            return NSLocalizedString("What is Quick access?", comment: "")
        }
    }
    
    var secondaryText: NSAttributedString {
        switch self {
        case .speakPhrases:
            return getSpeakPhrasesContentText()
            
        case .customizeSpeak:
            return getCustomizeSpeakContentText()
            
        case .changeVoice:
            return getChangeVoiceContentText()
            
        case .downloadVoice:
            return getDownloadVoiceContentText()
            
        case .personalVoice:
            return getPersonalVoiceContentText()
            
        case .quickAccess:
            return getQuickAccessContentText()
        }
    }

    static var allCasesWithoutPersonalVoice: [HelpContentType] {
        [.speakPhrases, .customizeSpeak, .changeVoice, .downloadVoice, .quickAccess]
    }

    // MARK: Speak Phrases
    
    private func getSpeakPhrasesContentText() -> NSAttributedString {
        let string = NSLocalizedString("Enter the text, that you want to be spoken, into the main, upper text field on the MyVoice screen. When you are ready to hear your phrase, tap Speak button under the text field. If you don’t hear your text, try to change the volume of your device. You can always have a quick look at your volume level on Speak button. The speaker icon shows your current volume setting.", comment: "")
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: Constants.fadedBlack,
            NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: Customize Speak
    
    private func getCustomizeSpeakContentText() -> NSAttributedString {
        let string = NSLocalizedString("On the Settings screen, you can customize some options, that will affect how your text is spoken. With Speech rate slider, you choose how fast your phrases will be said out loud. Speech pitch slider will change voice pitch. Try to experiment with it in Settings and find the best options that will suit you. You can also change the voice with its language that will be responsible for speaking all texts.", comment: "")
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: Constants.fadedBlack,
            NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: Change Voice
    
    private func getChangeVoiceContentText() -> NSAttributedString {
        let string = NSLocalizedString("To change the voice that will speak your phrases, go to the Settings screen. Select the Speech voice setting. You will see a new screen with a list of all voices available on your device. Each voice has its properties with its language. Some voices are also available in Enhanced mode - that means your phrases will sound more natural and with better pronunciation.", comment: "")
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: Constants.fadedBlack,
            NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: Download Voice
    
    private func getDownloadVoiceContentText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: NSLocalizedString("You can always download a bunch of new voices with support for more languages. You can’t do that from the MyVoice app. To do that:", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.fadedBlack,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        
        attributedString.append(.init(string: "\n\n"))
        
        let firstStep = NSMutableAttributedString(
            string: NSLocalizedString("1. Open the system", comment: "First part of bigger text"),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.fadedBlack,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        var textToAttribute = NSMutableAttributedString(
            string: NSLocalizedString("Settings app", comment: "Second part of bigger text"),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.black,
                NSAttributedString.Key.font: Fonts.Poppins.semibold(14.0).font
            ]
        )
        firstStep.append(NSAttributedString(string: " "))
        firstStep.append(textToAttribute)
        firstStep.append(NSAttributedString(string: "."))
        attributedString.append(firstStep)
        
        attributedString.append(.init(string: "\n\n"))

        let secondStep = NSMutableAttributedString(
            string: NSLocalizedString("2. Navigate to", comment: "First part of bigger text"),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        textToAttribute = NSMutableAttributedString(
            string: NSLocalizedString("Accessibility > VoiceOver > Speech", comment: "Second part of bigger text"),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.black,
                NSAttributedString.Key.font: Fonts.Poppins.semibold(14.0).font
            ]
        )
        secondStep.append(NSAttributedString(string: " "))
        secondStep.append(textToAttribute)
        secondStep.append(NSAttributedString(string: "."))
        attributedString.append(secondStep)
        
        attributedString.append(.init(string: "\n\n"))

        let thirdStep = NSMutableAttributedString(
            string: NSLocalizedString("3. Tap on Add New Language and select the language/dialect that you want to add.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        var textRange = thirdStep.mutableString.range(of: NSLocalizedString("Add New Language", comment: "Name for Settings app button"))
        thirdStep.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        attributedString.append(thirdStep)
        
        attributedString.append(.init(string: "\n\n"))

        let fourthStep = NSMutableAttributedString(
            string: NSLocalizedString("4. Select an added language from the Speech screen and choose Default or Enhanced quality of your voice.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        attributedString.append(fourthStep)
        
        attributedString.append(.init(string: "\n\n"))

        let fourthStepSummary = NSMutableAttributedString(
            string: NSLocalizedString("That’s it. If you go to MyVoice’s Select voice screen, you will see added voice on the list. You can now select it and all your phrases will be spoken with that voice.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.fadedBlack,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        attributedString.append(fourthStepSummary)
        
        attributedString.append(.init(string: "\n\n"))

        let stillLost = NSMutableAttributedString(
            string: NSLocalizedString("Still lost? Go to the official Apple tutorial.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        textRange = stillLost.mutableString.range(of: NSLocalizedString("Go to the official Apple tutorial.", comment: ""))
        stillLost.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        stillLost.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orangeMain ?? .orange, range: textRange)
        if let url = getHelpUrl(for: .voiceOver) {
            stillLost.addAttribute(NSAttributedString.Key.link, value: url, range: textRange)
        }
        attributedString.append(stillLost)
        
        return attributedString
    }
    
    // MARK: Quick Access
    
    private func getQuickAccessContentText() -> NSAttributedString {
        let string = NSLocalizedString("Quick access list helps you reach your saved phrases very fast, so you don’t need to always type them when you want to speak them. Enter the phrase into the text field and tap Save button. The text will appear on the Quick access list. To say it loud, just touch it. If you want to remove it, swipe your finger on the phrase to the left.", comment: "")
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: Constants.fadedBlack,
            NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: Personal Voice
    
    private func getPersonalVoiceContentText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: NSLocalizedString("Personal Voice is a generated, synthesized voice that sounds like your own. You can use it in the MyVoice app, like any other available voice. Personal Voice supports all customization settings including adjustment of speech rate and speech pitch. To use Personal Voice in the app:", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.fadedBlack,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        
        attributedString.append(.init(string: "\n\n"))
        
        let firstStep = NSMutableAttributedString(
            string: NSLocalizedString("1. Create a Personal Voice in the system Settings app. Navigate to Accessibility > Personal Voice > Create a Personal Voice. Follow the onscreen instructions to generate the voice. You will be informed by the system when Personal Voice is ready.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.fadedBlack,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        var textRange = firstStep.mutableString.range(of: NSLocalizedString("Accessibility > Personal Voice > Create a Personal Voice", comment: ""))
        firstStep.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        attributedString.append(firstStep)
        
        attributedString.append(.init(string: "\n\n"))

        let secondStep = NSMutableAttributedString(
            string: NSLocalizedString("2. After Personal Voice is generated, allow access to it in the system Settings app. Go to Accessibility > Personal Voice and enable Allow Apps to Request to Use option.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        textRange = secondStep.mutableString.range(of: NSLocalizedString("Accessibility > Personal Voice", comment: ""))
        secondStep.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        textRange = secondStep.mutableString.range(of: NSLocalizedString("Allow Apps to Request to Use", comment: ""))
        secondStep.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        attributedString.append(secondStep)
        
        attributedString.append(.init(string: "\n\n"))

        let thirdStep = NSMutableAttributedString(
            string: NSLocalizedString("3. Go to the MyVoice Settings screen and enable Personal Voice by tapping on the Personal Voice access button.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        textRange = thirdStep.mutableString.range(of: NSLocalizedString("MyVoice Settings screen", comment: ""))
        thirdStep.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        attributedString.append(thirdStep)
        
        attributedString.append(.init(string: "\n\n"))

        let fourthStep = NSMutableAttributedString(
            string: NSLocalizedString("4. After allowing access, your generated voice will be visible to choose on the Select voice screen.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        textRange = fourthStep.mutableString.range(of: NSLocalizedString("Select voice screen", comment: ""))
        fourthStep.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        attributedString.append(fourthStep)
        
        attributedString.append(.init(string: "\n\n"))

        let fourthStepSummary = NSMutableAttributedString(
            string: NSLocalizedString("If you have denied access to Personal Voice, you can still change your settings from the system Settings app.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.fadedBlack,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        attributedString.append(fourthStepSummary)
        
        attributedString.append(.init(string: "\n\n"))

        let stillLost = NSMutableAttributedString(
            string: NSLocalizedString("Still lost? Go to the official Apple tutorial.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        textRange = stillLost.mutableString.range(of: NSLocalizedString("Go to the official Apple tutorial.", comment: ""))
        stillLost.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        stillLost.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orangeMain ?? .orange, range: textRange)
        if let url = getHelpUrl(for: .personalVoice) {
            stillLost.addAttribute(NSAttributedString.Key.link, value: url, range: textRange)
        }
        attributedString.append(stillLost)
        
        return attributedString
    }
    
    // MARK: Helper methods
    
    private func getHelpUrl(for type: HelpUrlType) -> URL? {
        let language = Bundle.main.preferredLocalizations.urlLanguage
        
        return type.getUrl(for: language)
    }
}

fileprivate enum HelpUrlType {
    enum Language {
        case english
        case polish
        
        var domain: String {
            switch self {
            case .english: return "en-gb"
            case .polish: return "pl-pl"
            }
        }
    }
    
    case voiceOver
    case personalVoice
    
    func getUrl(for language: Language) -> URL? {
        switch self {
        case .voiceOver:
            return URL(string: "https://support.apple.com/\(language.domain)/HT202362")
            
        case .personalVoice:
            return URL(string: "https://support.apple.com/\(language.domain)/HT213878")
        }
    }
}

fileprivate enum Constants {
    static var fadedBlack: UIColor { (UIColor.blackCustom ?? .black).withAlphaComponent(0.85) }
    static var black: UIColor { .blackCustom ?? .black }
}

fileprivate extension [String] {
    var urlLanguage: HelpUrlType.Language {
        switch first {
        case "pl": return .polish
        default: return .english
        }
    }
}
