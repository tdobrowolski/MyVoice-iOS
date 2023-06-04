//
//  QuickPhraseTableViewCell.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 20/01/2021.
//

import UIKit
import RxSwift

final class QuickPhraseTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var tapHandlerButton: TouchHandlerButton!
    
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var separator: UIView!
    
    let isSpeaking = BehaviorSubject<Bool>(value: false)
    lazy var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 62).isActive = true
    }
    
    func setupCell(phrase: String, isFirstCell: Bool, isLastCell: Bool) {
        bind()
        setupIcon()

        phraseLabel.text = phrase

        selectionStyle = .none
        backgroundColor = .clear

        backgroundContainerView.clipsToBounds = true
        backgroundContainerView.layer.masksToBounds = true

        if isFirstCell {
            tipLabel.text = NSLocalizedString("Tip: Select text to say it loud.", comment: "")
            tipLabel.isHidden = false
        } else {
            tipLabel.isHidden = true
        }

        separator.isHidden = isLastCell
    }
    
    private func bind() {
        isSpeaking.subscribe(onNext: { [weak self] isSpeaking in
            if isSpeaking == false {
                self?.setupIcon(isSpeaking: false)
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: Setuping layout
    
    func setupIcon(isSpeaking: Bool = false) {
        iconContainerView.layer.cornerRadius = self.iconContainerView.frame.width / 2
        iconImageView.image = UIImage(systemName: "waveform", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))

        if isSpeaking {
            iconImageView.tintColor = .orangeMain
            iconContainerView.backgroundColor = .orangeLight
        } else {
            iconImageView.tintColor = .blueDark
            iconContainerView.backgroundColor = .blueLight
        }
    }
    
    func setTipVisibility(isHidden: Bool) {
        tipLabel.text = isHidden ? nil : NSLocalizedString("Tip: Select text to say it loud.", comment: "")
        tipLabel.isHidden = isHidden
    }
    
    override func prepareForReuse() {
        phraseLabel.text = nil
        setTipVisibility(isHidden: true)
        disposeBag = DisposeBag()
    }
}
