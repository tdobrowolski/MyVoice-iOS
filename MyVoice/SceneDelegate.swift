//
//  SceneDelegate.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let mainViewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: mainViewModel, nibName: Nib.mainViewController.name)
        let navigationController = DefaultNavigationController(rootViewController: mainViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

