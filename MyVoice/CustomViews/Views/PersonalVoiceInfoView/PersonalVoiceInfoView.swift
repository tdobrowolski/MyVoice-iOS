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
        
        contentView.backgroundColor = .blueLight
        backgroundColor = .clear
        
        roundedContainerView.backgroundColor = .whiteCustom
        roundedContainerView.layer.cornerRadius = 10.0
        roundedContainerView.layer.masksToBounds = true
        
        iconContainer.backgroundColor = .purpleLight
        iconContainer.layer.cornerRadius = iconContainer.frame.width / 2
        iconContainer.layer.masksToBounds = true
        
        titleLabel.font = Fonts.Poppins.semibold(14.0).font
        subtitleLabel.font = Fonts.Poppins.medium(12.0).font
        learnMoreButton.titleLabel?.font = Fonts.Poppins.medium(12.0).font
        
        primaryButton.setupLayout(forTitle: "Grant access", type: .primary)
        secondaryButton.setupLayout(forTitle: "Close", type: .secondary)
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
