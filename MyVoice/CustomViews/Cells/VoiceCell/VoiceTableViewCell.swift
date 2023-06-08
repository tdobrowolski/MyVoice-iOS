//
//  VoiceTableViewCell.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 06/02/2021.
//

import UIKit
import AVFoundation

final class VoiceTableViewCell: UITableViewCell {
    @IBOutlet weak var voiceLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    func setupCell(languageName: String, voiceName: String, voiceQuality: AVSpeechSynthesisVoiceQuality, voiceGender: AVSpeechSynthesisVoiceGender, isSelected: Bool) {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        voiceLabel.text = "\(languageName) - \(voiceName)"
        var voiceGenderText = NSMutableAttributedString(
            string: NSLocalizedString("Unspecified", comment: "Unspecified"),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueDark ?? .black]
        )

        switch voiceGender {
        case .male:
            voiceGenderText = NSMutableAttributedString(
                string: NSLocalizedString("Male", comment: "Male"),
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueDark ?? .black]
            )

        case .female:
            voiceGenderText = NSMutableAttributedString(
                string: NSLocalizedString("Female", comment: "Female"),
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueDark ?? .black]
            )

        default:
            break
        }

        let voiceQualityText = NSMutableAttributedString(
            string: " • ",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueDark ?? .black]
        )

        switch voiceQuality {
        case .default:
            voiceQualityText.append(
                NSMutableAttributedString(
                    string: NSLocalizedString("Default quality", comment: "Default quality"),
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueDark ?? .black]
                )
            )

        case .enhanced:
            voiceQualityText.append(
                NSMutableAttributedString(
                    string: NSLocalizedString("Enhanced quality", comment: "Enhanced quality"),
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.orangeMain ?? .orange]
                )
            )

        default:
            voiceQualityText.append(
                NSMutableAttributedString(
                    string: NSLocalizedString("Unknown quality", comment: "Unknown quality"),
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueDark ?? .black]
                )
            )
        }
        voiceGenderText.append(voiceQualityText)
        additionalInfoLabel.attributedText = voiceGenderText
        checkmarkImageView.isHidden = isSelected == false
        checkmarkImageView.image = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        voiceLabel.text = nil
        additionalInfoLabel.text = nil
        checkmarkImageView.isHidden = true
    }
}
