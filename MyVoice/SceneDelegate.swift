//
//  SceneDelegate.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var appRouter = CompositionRoot.shared.appRouter

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(frame: windowScene)
        appRouter.setupAppWindow(window)
    }
}

