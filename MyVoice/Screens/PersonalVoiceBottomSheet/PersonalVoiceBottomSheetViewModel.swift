//
//  PersonalVoiceBottomSheetViewModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 03/10/2023.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
final class PersonalVoiceBottomSheetViewModel: BaseViewModel, ObservableObject {
    enum AccessType {
        case accessNotSpecified
        case accessDenied

        var helperText: String? {
            switch self {
            case .accessNotSpecified:
                return nil

            case .accessDenied:
                return NSLocalizedString("Access to Personal Voice is not granted. First, make sure you've granted Personal Voice access to third-party apps in Accessiblity > Personal Voice.", comment: "")
            }
        }

        // Action Button for .accessDenied is not used, because of problems with iOS Settings navigation.
        var actionButtonText: String {
            switch self {
            case .accessNotSpecified:
                return NSLocalizedString("Allow access", comment: "")

            case .accessDenied:
                return NSLocalizedString("Allow in Settings", comment: "")
            }
        }

        var showActionButton: Bool {
            switch self {
            case .accessNotSpecified: return true
            case .accessDenied: return false
            }
        }
    }

    weak var navigationController: UINavigationController?

    var accessType: AccessType

    private let personalVoiceService: PersonalVoiceService
    private let onClose: () -> Void

    init(
        personalVoiceService: PersonalVoiceService,
        onClose: @escaping () -> Void
    ) {
        self.personalVoiceService = personalVoiceService
        self.onClose = onClose
        self.accessType = .accessNotSpecified // (try? personalVoiceService.authorizationStatus.value())?.toPersonalVoiceBottomSheetType ?? .accessNotSpecified
    }

    func didTapActionButtonAccess() async {
        switch accessType {
        case .accessNotSpecified:
            await requestPersonalVoiceAccess()

        case .accessDenied:
            let settingsURLString = UIApplication.openSettingsURLString

            guard let settingsUrl = URL(string: settingsURLString),
                  await UIApplication.shared.canOpenURL(settingsUrl) else { return }

            await UIApplication.shared.open(settingsUrl)
        }
    }

    @MainActor
    func didTapLearnMore() {
        showHelpForPersonalVoice()
    }

    @MainActor
    func didTapClose() {
        onClose()
    }

    func requestPersonalVoiceAccess() async {
        let _ = await personalVoiceService.requestPersonalVoiceAccess()

        await didTapClose()
    }

    private func showHelpForPersonalVoice() {
        let helpViewModel = HelpViewModel(
            supportsPersonalVoice: true,
            onDone: { [weak self] in self?.navigationController?.dismiss(animated: true) }
        )
        let helpViewController = HelpView(
            viewModel: helpViewModel,
            contentTypeToExpand: .personalVoice
        ).asViewController
        let helpNavigationController = DefaultNavigationController(rootViewController: helpViewController)

        navigationController?.present(helpNavigationController, animated: true, completion: nil)
    }
}
