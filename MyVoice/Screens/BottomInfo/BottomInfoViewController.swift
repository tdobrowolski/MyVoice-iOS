//
//  BottomInfoViewController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 03/10/2023.
//

import UIKit

// FIXME: Improve height of action buttons
// FIXME: Improve primary purple for Dark Mode

class BottomInfoViewController: BaseViewController<BottomInfoViewModel> {
    @IBOutlet weak var personalVoiceInfoView: PersonalVoiceInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalVoiceInfoView.delegate = self
        adjustContentBottomConstraintIfNeeded()
    }
    
    private func adjustContentBottomConstraintIfNeeded() {
        let bottomSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.bottom
        if bottomSafeArea == 0 { personalVoiceInfoView.adjustBottomSpacingForNoSafeArea() }
    }
    
    private func learnMoreDidTap() {
        let helpViewModel = HelpViewModel()
        let helpViewController = HelpView(
            contentTypeToExpand: .personalVoice,
            onDone: { [weak self] in self?.dismiss(animated: true) }
        ).asViewController
        let helpNavigationController = DefaultNavigationController(rootViewController: helpViewController)
        
        present(helpNavigationController, animated: true, completion: nil)
    }
}

extension BottomInfoViewController: PersonalVoiceInfoViewDelegate {
    func didTapLearnMore() {
        learnMoreDidTap()
    }
    
    func didTapAllowAccess() {
        navigationController?.dismiss(animated: true, completion: nil) // TODO: Maybe use completion instead for Task?
        if #available(iOS 17.0, *) {
            Task { await viewModel.didTapGrantAccess() }
        }
    }
    
    func didTapClose() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
