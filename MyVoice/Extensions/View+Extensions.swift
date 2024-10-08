//
//  View+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/10/2023.
//

import SwiftUI
import UIKit.UIViewController

extension View {
    var asViewController: UIViewController {
        UIHostingController(rootView: self)
    }
}
