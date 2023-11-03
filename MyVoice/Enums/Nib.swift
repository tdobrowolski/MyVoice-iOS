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
    case defaultCell
    
    var name: String {
        switch self {
        case .helpViewController: return "HelpViewController"
        case .settingsViewController: return "SettingsViewController"
        case .languagePickerViewController: return "LanguagePickerViewController"
        case .personalVoiceBottomSheetViewController: return "PersonalVoiceBottomSheetViewController"
        case .mainViewController: return "MainViewController"
        case .quickPhraseTableViewCell: return "QuickPhraseTableViewCell"
        case .sliderTableViewCell: return "SliderTableViewCell"
        case .voiceTableViewCell: return "VoiceTableViewCell"
        case .defaultCell: return "defaultCell"
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
