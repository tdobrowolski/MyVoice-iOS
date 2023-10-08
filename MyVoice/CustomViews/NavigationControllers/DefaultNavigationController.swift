//
//  DefaultNavigationController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit

final class DefaultNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = .blueLight ?? .red
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.blackCustom ?? .black,
            NSAttributedString.Key.font: Fonts.Poppins.bold(17.0).font
        ]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
}
