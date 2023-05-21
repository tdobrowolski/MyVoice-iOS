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

        navigationBar.barTintColor = UIColor(named: "Blue (Light)") ?? .red
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "Black") ?? .black,
            NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17)
        ]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

}
