//
//  OrientationManager.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 12/09/2025.
//

import SwiftUI

final class OrientationManager: ObservableObject {
    @Published var type: UIInterfaceOrientationMask = System.defaultOrientation

    static let shared = OrientationManager()
}
