//
//  AppRouter.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 21/05/2023.
//

import UIKit
import Combine

final class AppRouter {
    private let appBuilder: AppBuilder

    private var appWindow: UIWindow?

    init(appBuilder: AppBuilder) {
        self.appBuilder = appBuilder
    }

    func setupAppWindow(_ window: UIWindow?) {
        appWindow = window
        appWindow?.window = appBuilder.build()
        appWindow?.makeKeyAndVisible()

        // TODO: Setup global tint on appWindow
        // TODO: Setup UIKit params from here
    }
}
