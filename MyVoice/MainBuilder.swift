//
//  MainBuilder.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 21/05/2023.
//

struct MainBuilder {
    func build() -> UIViewController {
        let viewModel = MainViewModel()
        let viewController = MainView(viewModel: viewModel).asViewController()

        return viewController
    }
}
