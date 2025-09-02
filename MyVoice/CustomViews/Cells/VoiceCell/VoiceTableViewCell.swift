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
    @IBOutlet weak var separatorView: UIView!
    
    func setupCell(
        voiceName: String,
        voiceQuality: AVSpeechSynthesisVoiceQuality,
        voiceGender: AVSpeechSynthesisVoiceGender,
        isPersonalVoice: Bool,
        isLastInSection: Bool,
        isSelected: Bool
    ) {
        voiceLabel.text = voiceName
        
        if isPersonalVoice {
            setupInfoLabelForPersonalVoice()
        } else {
            setupInfoLabelForNormalVoice(voiceQuality: voiceQuality, voiceGender: voiceGender)
        }
        
        separatorView.isHidden = isLastInSection
        checkmarkImageView.isHidden = isSelected == false
        checkmarkImageView.image = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))

        if isSelected {
            accessibilityTraits.insert(.selected)
        } else {
            accessibilityTraits.remove(.selected)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .clear
        backgroundColor = .whiteCustom
        
        voiceLabel.font = Fonts.Poppins.semibold(14.0).font
        additionalInfoLabel.font = Fonts.Poppins.medium(12.0).font
    }
    
    private func setupInfoLabelForNormalVoice(
        voiceQuality: AVSpeechSynthesisVoiceQuality,
                                              voiceGender: AVSpeechSynthesisVoiceGender
    ) {
        var voiceGenderText: NSMutableAttributedString

        voiceGenderText = NSMutableAttributedString(
            string: voiceGender.title,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueDark ?? .black]
        )

        let voiceQualityText = NSMutableAttributedString(
            string: " • ",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueDark ?? .black]
        )

        voiceQualityText.append(
            NSMutableAttributedString(
                string: voiceQuality.title,
                attributes: [NSAttributedString.Key.foregroundColor: voiceQuality.foregroundColor]
            )
        )
        
        voiceGenderText.append(voiceQualityText)
        additionalInfoLabel.attributedText = voiceGenderText

        additionalInfoLabel.accessibilityLabel = voiceGender.title
    }
    
    private func setupInfoLabelForPersonalVoice() {
        let tint = UIColor.purpleMain ?? .purple
        let personalVoiceText = NSMutableAttributedString()
        
        if let sparklesIcon = UIImage(systemName: "sparkles") {
            let imageAttachment = NSTextAttachment(image: sparklesIcon.withTintColor(tint))
            personalVoiceText.append(NSAttributedString(attachment: imageAttachment))
            personalVoiceText.append(NSMutableAttributedString(string: " "))
        }
        personalVoiceText.append(
            NSMutableAttributedString(
                string: NSLocalizedString("Personal Voice", comment: "Personal Voice"),
                attributes: [NSAttributedString.Key.foregroundColor: tint]
            )
        )
        
        additionalInfoLabel.attributedText = personalVoiceText
        additionalInfoLabel.accessibilityLabel = personalVoiceText.string
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        voiceLabel.text = nil
        additionalInfoLabel.text = nil
        checkmarkImageView.isHidden = true
    }
}
