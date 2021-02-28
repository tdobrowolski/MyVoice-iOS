//
//  VoiceCellTableViewCell.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 06/02/2021.
//

import UIKit
import AVFoundation

final class VoiceCellTableViewCell: UITableViewCell {

    @IBOutlet weak var voiceLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    func setupCell(languageName: String, voiceName: String, voiceQuality: AVSpeechSynthesisVoiceQuality, voiceGender: AVSpeechSynthesisVoiceGender, isSelected: Bool) {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.voiceLabel.text = "\(languageName) - \(voiceName)"
        var voiceGenderText = NSMutableAttributedString(string: NSLocalizedString("Unspecified", comment: "Unspecified"), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Blue (Dark)") ?? .black])
        switch voiceGender {
        case .male:
            voiceGenderText = NSMutableAttributedString(string: NSLocalizedString("Male", comment: "Male"), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Blue (Dark)") ?? .black])
        case .female:
            voiceGenderText = NSMutableAttributedString(string: NSLocalizedString("Female", comment: "Female"), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Blue (Dark)") ?? .black])
        default:
            break
        }
        let voiceQualityText = NSMutableAttributedString(string: " • ", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Blue (Dark)") ?? .black])
        switch voiceQuality {
        case .default:
            voiceQualityText.append(NSMutableAttributedString(string: NSLocalizedString("Default quality", comment: "Default quality"), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Blue (Dark)") ?? .black]))
        case .enhanced:
            voiceQualityText.append(NSMutableAttributedString(string: NSLocalizedString("Enhanced quality", comment: "Enhanced quality"), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Orange (Main)") ?? .orange]))
        default:
            voiceQualityText.append(NSMutableAttributedString(string: NSLocalizedString("Unknown quality", comment: "Unknown quality"), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Blue (Dark)") ?? .black]))
        }
        voiceGenderText.append(voiceQualityText)
        self.additionalInfoLabel.attributedText = voiceGenderText
        self.checkmarkImageView.isHidden = isSelected == false
        self.checkmarkImageView.image = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.voiceLabel.text = nil
        self.additionalInfoLabel.text = nil
        self.checkmarkImageView.isHidden = true
    }
}
