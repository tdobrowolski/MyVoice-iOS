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

        configureStyle()
    }

    private func configureStyle() {
        let navigationBarAppearance = UINavigationBarAppearance()

        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .background ?? .red
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.blackCustom ?? .black,
            NSAttributedString.Key.font: Fonts.Poppins.bold(17.0).font
        ]

        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.compactAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
    }
}
