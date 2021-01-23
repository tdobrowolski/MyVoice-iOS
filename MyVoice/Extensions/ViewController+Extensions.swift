//
//  ViewController+Extensions.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit

extension UIViewController {
    
    // MARK: Debugging
    
    func logSuccess(with text: String) {
        print("🟢 Success: \(text)")
    }
    
    func logWarning(with text: String) {
        print("🟡 Warning: \(text)")
    }
    
    func logError(with text: String) {
        print("🔴 Error: \(text)")
    }
    
    func logError(with error: Error) {
        print("🔴 Error: \(error.localizedDescription)")
    }
}
