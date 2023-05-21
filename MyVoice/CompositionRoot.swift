//
//  CompositionRoot.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 21/05/2023.
//

import Foundation

final class CompositionRoot {
    static let shared = CompositionRoot()

    private(set) lazy var appRouter = AppRouter()

    private lazy var appBuilder = AppBuilder(
        mainBuilder: mainBuilder
    )

    private var mainBuilder: MainBuilder {
        .init()
    }
}
