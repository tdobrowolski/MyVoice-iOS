//
//  View+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 21/05/2023.
//

import UIKit
import SwiftUI

extension View {
    func asViewController() -> UIViewController {
        ViewController(rootView: self)
    }
}
