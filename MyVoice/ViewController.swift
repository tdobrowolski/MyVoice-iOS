//
//  ViewController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 21/05/2023.
//

import UIKit
import SwiftUI

// TODO: Place to handle custom NavigationBar like in metapro
// Replace with normal HostingController if this not needed

final class ViewController<Content>: UIHostingController<Content> where Content: View {
    init(rootView: Content) {
        super.init(rootView: rootView)
    }

    @MainActor
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
