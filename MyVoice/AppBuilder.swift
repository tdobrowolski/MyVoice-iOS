//
//  AppBuilder.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 21/05/2023.
//

import UIKit

final class AppBuilder {
    private let mainBuilder: MainBuilder

    init(mainBuilder: MainBuilder) {
        self.mainBuilder = mainBuilder
    }

    func build() -> UIViewController {
        let viewController = mainBuilder.build()

        return NavigationController(rootViewController: viewController)
    }
}
