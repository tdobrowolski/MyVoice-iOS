//
//  QuickPhraseTableViewCell.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 20/01/2021.
//

import UIKit
import RxSwift

class QuickPhraseTableViewCell: UITableViewCell {

    enum CellOrderType {
        case onlyCell
        case firstCell
        case defaultCell
        case lastCell
    }
    
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var tapHandlerButton: UIButton!
    
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 63).isActive = true
    }
    
    func setupCell(phrase: String, type: CellOrderType) {
        self.setupIcon()
        self.phraseLabel.text = phrase
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.backgroundContainerView.clipsToBounds = true
        self.backgroundContainerView.layer.masksToBounds = true
        switch type {
        case .onlyCell:
            self.tipLabel.text = "Tip: Select text to say it loud."
            self.tipLabel.isHidden = false
            self.backgroundContainerView.layer.cornerRadius = 16
            self.backgroundContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case .firstCell:
            self.tipLabel.text = "Tip: Select text to say it loud."
            self.tipLabel.isHidden = false
            self.backgroundContainerView.layer.cornerRadius = 16
            self.backgroundContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .defaultCell:
            self.tipLabel.isHidden = true
        case .lastCell:
            self.tipLabel.isHidden = true
            self.backgroundContainerView.layer.cornerRadius = 16
            self.backgroundContainerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    // MARK: Setuping layout
    
    func setupIcon(isSpeaking: Bool = false) {
        self.iconContainerView.layer.cornerRadius = self.iconContainerView.frame.width / 2
        self.iconImageView.image = UIImage(systemName: "waveform", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
        if isSpeaking {
            self.iconImageView.tintColor = UIColor(named: "Orange (Main)")
            self.iconContainerView.backgroundColor = UIColor(named: "Orange (Light)")
        } else {
            self.iconImageView.tintColor = UIColor(named: "Blue (Dark)")
            self.iconContainerView.backgroundColor = UIColor(named: "Blue (Light)")
        }
    }    
    
    override func prepareForReuse() {
        self.phraseLabel.text = nil
        self.tipLabel.text = nil
        self.tipLabel.isHidden = true
        self.backgroundContainerView.layer.cornerRadius = 0
        self.backgroundContainerView.layer.maskedCorners = []
        self.tapHandlerButton.tag = 0
    }
}
