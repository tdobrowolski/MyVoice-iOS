//
//  SwitchTableViewCell.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 04/09/2025.
//

import UIKit
import RxSwift

final class SwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var `switch`: UISwitch!

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    

    lazy var disposeBag = DisposeBag()

    func setupCell(text: String) {
        label.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .clear
        backgroundColor = .whiteCustom
        
        label.font = Fonts.Poppins.medium(15.0).font
        label.textColor = .blackCustom ?? .black
        label.minimumScaleFactor = 0.9
        label.adjustsFontSizeToFitWidth = true
        label.allowsDefaultTighteningForTruncation = true

        if #available(iOS 26.0, *) {
            topConstraint.constant = 12.0
            bottomConstraint.constant = 12.0
        } else {
            topConstraint.constant = 8.0
            bottomConstraint.constant = 8.0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        `switch`.isOn = false
    }
}
