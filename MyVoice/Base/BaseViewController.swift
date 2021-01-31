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
        self.bindViewModel(viewModel: viewModel)
    }
    
    func bindViewModel(viewModel: BaseViewModel) { }
    
    
    /// Adds gesture recognizer for dismissing keyboard on the view
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    deinit {
        print("deinit: \(self)")
    }
}
