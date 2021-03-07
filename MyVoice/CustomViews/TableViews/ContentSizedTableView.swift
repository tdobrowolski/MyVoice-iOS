//
//  ContentSizedTableView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 23/01/2021.
//

import UIKit

final class ContentSizedTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
    }
}
