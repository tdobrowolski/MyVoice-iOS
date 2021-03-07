//
//  CustomScrollView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 07/03/2021.
//

import UIKit

final class CustomScrollView: UIScrollView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: TouchHandlerButton.self) { return true }
        return super.touchesShouldCancel(in: view)
    }

}
