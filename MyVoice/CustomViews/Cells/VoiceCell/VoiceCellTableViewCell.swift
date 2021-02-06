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
        var voiceGenderText = "Unspecified"
        switch voiceGender {
        case .male:
            voiceGenderText = "Male"
        case .female:
            voiceGenderText = "Female"
        default:
            break
        }
        var voiceQualityText = " • "
        switch voiceQuality {
        case .default:
            voiceQualityText.append("Default quality")
        case .enhanced:
            voiceQualityText.append("Enhanced quality")
        default:
            voiceQualityText.append("Unknown quality")
        }
        self.additionalInfoLabel.text = voiceGenderText.appending(voiceQualityText)
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
