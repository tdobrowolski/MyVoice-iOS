//
//  BaseViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 18/01/2021.
//

class BaseViewModel: NSObject {    
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
    
    deinit {
        print("deinit: \(self)")
    }
}
