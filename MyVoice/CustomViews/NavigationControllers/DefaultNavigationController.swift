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

        self.navigationBar.barTintColor = UIColor(named: "Blue (Light)") ?? .red
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "Black") ?? .black,
                                                  NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17)]
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }

}
