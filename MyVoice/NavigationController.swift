//
//  NavigationController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 21/05/2023.
//

import UIKit
import SwiftUI

final class NavigationController: UINavigationController {

    init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        setupAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupAppearance() {
        // TODO: Style NavigationBar
    }

}
