//
//  SwitchTableViewCell.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 04/09/2025.
//

import UIKit
import RxSwift

final class SwitchTableViewCell: UITableViewCell {
    lazy var `switch` = UISwitch()
    lazy var disposeBag = DisposeBag()

    var text: String? {
        didSet {
            var content = defaultContentConfiguration()

            content.textProperties.font = Fonts.Poppins.medium(15.0).font
            content.textProperties.color = .blackCustom ?? .black
            content.textProperties.minimumScaleFactor = 0.9
            content.textProperties.adjustsFontSizeToFitWidth = true
            content.textProperties.allowsDefaultTighteningForTruncation = true
            content.text = text

            contentConfiguration = content
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .clear
        backgroundColor = .whiteCustom
        selectionStyle = .none
        accessoryView = `switch`
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        text = nil
        `switch`.isOn = false
    }
}
