//
//  Nib.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/06/2023.
//

enum Nib {
    // MARK: ViewControllers
    case helpViewController
    case settingsViewController
    case languagePickerViewController
    case personalVoiceBottomSheetViewController
    case mainViewController
    
    // MARK: Cells
    case quickPhraseTableViewCell
    case sliderTableViewCell
    case voiceTableViewCell
    case switchTableViewCell
    case defaultCell
    
    var name: String {
        switch self {
        case .helpViewController: "HelpViewController"
        case .settingsViewController: "SettingsViewController"
        case .languagePickerViewController: "LanguagePickerViewController"
        case .personalVoiceBottomSheetViewController: "PersonalVoiceBottomSheetViewController"
        case .mainViewController: "MainViewController"
        case .quickPhraseTableViewCell: "QuickPhraseTableViewCell"
        case .sliderTableViewCell: "SliderTableViewCell"
        case .voiceTableViewCell: "VoiceTableViewCell"
        case .switchTableViewCell: "SwitchTableViewCell"
        case .defaultCell: "defaultCell"
        }
    }
    
    var cellIdentifier: String {
        switch self {
        case .quickPhraseTableViewCell:
            return "quickPhraseTableViewCell"
            
        case .sliderTableViewCell:
            return "sliderCell"
            
        case .voiceTableViewCell:
            return "voiceCell"

        case .switchTableViewCell:
            return "switchCell"

        case .defaultCell:
            return "defaultCell"
            
        case .helpViewController,
                .settingsViewController,
                .languagePickerViewController,
                .personalVoiceBottomSheetViewController,
                .mainViewController:
            assertionFailure("This type of Nib doesn't support cellIdentifier.")
            
            return ""
        }
    }
}
