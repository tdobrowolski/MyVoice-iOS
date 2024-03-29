//
//  BaseViewController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit
import RxSwift

class BaseViewController<BaseViewModel>: UIViewController {
    let viewModel: BaseViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: BaseViewModel, nibName: String) {
        self.viewModel = viewModel

        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel(viewModel)
    }
    
    func bindViewModel(_ viewModel: BaseViewModel) { }
    
    /// Adds gesture recognizer for dismissing keyboard on the view
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissKeyboard() { view.endEditing(true) }
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        alert.preferredAction = alert.actions.last
        
        present(alert, animated: true, completion: nil)
    }
    
    deinit { print("deinit: \(self)") }
}
