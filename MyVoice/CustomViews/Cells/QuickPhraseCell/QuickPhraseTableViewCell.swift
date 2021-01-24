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
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 62).isActive = true
    }
    
    func setupCell(phrase: String, isFirstCell: Bool) {
        self.setupIcon()
        self.phraseLabel.text = phrase
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.backgroundContainerView.clipsToBounds = true
        self.backgroundContainerView.layer.masksToBounds = true
        if isFirstCell {
            self.tipLabel.text = "Tip: Select text to say it loud."
            self.tipLabel.isHidden = false
        } else {
            self.tipLabel.isHidden = true
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
    
    func setTipVisibility(isHidden: Bool) {
        self.tipLabel.text = isHidden ? nil : "Tip: Select text to say it loud."
        self.tipLabel.isHidden = isHidden
    }
    
    override func prepareForReuse() {
        self.phraseLabel.text = nil
        self.setTipVisibility(isHidden: true)
        self.tapHandlerButton.tag = 0
    }
}
