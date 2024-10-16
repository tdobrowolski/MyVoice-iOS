//
//  AppSignal.swift
//  Shared
//
//  Created by Tobiasz Dobrowolski on 16/10/2024.
//

import Combine

public final class AppSignal {
    public static let shared: AppSignal = .init()

    public var shouldPrepareInstantTyping = false

    private init() { }
}
