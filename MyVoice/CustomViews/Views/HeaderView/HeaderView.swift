//
//  HeaderView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 18/06/2023.
//

import UIKit

final class HeaderView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupLayout()
    }
    
    private func setupLayout() {
        Bundle.main.loadNibNamed("HeaderView", owner: self)
        
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        label.font = Fonts.Poppins.medium(14.0).font
        label.textColor = .blueDark
        
        backgroundColor = .clear
    }
}
