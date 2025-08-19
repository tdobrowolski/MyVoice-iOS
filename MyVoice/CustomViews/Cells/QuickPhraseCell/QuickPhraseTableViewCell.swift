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
    
    @IBOutlet weak var separatorView: UIView!
    
    let isSpeaking = BehaviorSubject<Bool>(value: false)
    lazy var disposeBag = DisposeBag()
    
    func setupCell(phrase: String, isFirstCell: Bool, isLastCell: Bool) {
        bind()
        setupIcon()

        phraseLabel.text = phrase

        if isFirstCell {
            tipLabel.text = NSLocalizedString("Tip: Select text to say it loud.", comment: "")
            tipLabel.isHidden = false
        } else {
            tipLabel.isHidden = true
        }

        separatorView.isHidden = isLastCell
    }
    
    private func bind() {
        isSpeaking
            .subscribe { [weak self] isSpeaking in
                if isSpeaking == false {
                    self?.setupIcon(isSpeaking: false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: Setuping layout
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
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
    
    private func setupLayout() {
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 62).isActive = true
        
        phraseLabel.font = Fonts.Poppins.semibold(14.0).font
        tipLabel.font = Fonts.Poppins.medium(14.0).font

        selectionStyle = .none
        backgroundColor = .clear

        backgroundContainerView.clipsToBounds = true
        backgroundContainerView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        phraseLabel.text = nil
        setTipVisibility(isHidden: true)
        disposeBag = DisposeBag()
    }
}
