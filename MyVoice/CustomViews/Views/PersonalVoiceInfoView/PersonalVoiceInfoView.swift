//
//  PersonalVoiceInfoView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 06/10/2023.
//

import UIKit

protocol PersonalVoiceInfoViewDelegate: AnyObject {
    func didTapLearnMore()
    func didTapAllowAccess()
    func didTapClose()
}

final class PersonalVoiceInfoView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var roundedContainerView: UIView!
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var primaryButton: InfoButton!
    @IBOutlet weak var secondaryButton: InfoButton!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: PersonalVoiceInfoViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupLayout()
    }
    
    private func setupLayout() {
        Bundle.main.loadNibNamed("PersonalVoiceInfoView", owner: self)
        
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        contentView.backgroundColor = .background
        backgroundColor = .clear
        
        roundedContainerView.backgroundColor = .whiteCustom
        roundedContainerView.layer.cornerRadius = 10.0
        roundedContainerView.layer.masksToBounds = true
        
        iconContainer.backgroundColor = .purpleLight
        iconContainer.layer.cornerRadius = iconContainer.frame.width / 2
        iconContainer.layer.masksToBounds = true
        
        titleLabel.text = NSLocalizedString("Personal Voice now available", comment: "")
        subtitleLabel.text = NSLocalizedString("You can now use your generated Personal Voice to read phrases within the MyVoice app. To use your generated voices, grant access to it.", comment: "")
        learnMoreButton.setTitle(NSLocalizedString("Learn more about Personal Voice", comment: ""), for: .normal)
        
        titleLabel.font = Fonts.Poppins.bold(16.0).font
        subtitleLabel.font = Fonts.Poppins.medium(13.0).font
        learnMoreButton.titleLabel?.font = Fonts.Poppins.medium(13.0).font
        
        titleLabel.allowsDefaultTighteningForTruncation = true
        subtitleLabel.allowsDefaultTighteningForTruncation = true
        learnMoreButton.titleLabel?.allowsDefaultTighteningForTruncation = true
        
        primaryButton.setupLayout(forTitle: NSLocalizedString("Allow access", comment: ""), type: .primary)
        secondaryButton.setupLayout(forTitle: NSLocalizedString("Close", comment: ""), type: .secondary)
        
        primaryButton.titleLabel?.allowsDefaultTighteningForTruncation = true
        secondaryButton.titleLabel?.allowsDefaultTighteningForTruncation = true
        
        primaryButton.titleLabel?.font = Fonts.Poppins.semibold(14.0).font
        secondaryButton.titleLabel?.font = Fonts.Poppins.medium(14.0).font
    }
    
    func adjustBottomSpacingForNoSafeArea() {
        containerBottomConstraint.constant = 16.0
    }
    
    @IBAction func didTapLearnMore(_ sender: UIButton) {
        delegate?.didTapLearnMore()
    }
    
    @IBAction func primaryButtonDidTap(_ sender: InfoButton) {
        delegate?.didTapAllowAccess()
    }
    
    @IBAction func secondaryButtonDidTap(_ sender: InfoButton) {
        delegate?.didTapClose()
    }
}
