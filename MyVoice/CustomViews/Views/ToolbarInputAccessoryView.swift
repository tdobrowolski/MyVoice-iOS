//
//  ToolbarInputAccessoryView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 19/08/2025.
//

import UIKit

final class ToolbarInputAccessoryView: UIInputView {
    private enum Constants {
        static let toolbarHeight: CGFloat = 44.0
        static let bottomPadding: CGFloat = 16.0
    }

    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        // MARK: Pasteboard Button Item

        let pasteboardItem = UIBarButtonItem(
            image: UIImage(systemName: "list.clipboard", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), // TODO: Debug on < iOS 16.0
            primaryAction: .init(handler: { [weak self] _ in self?.pasteboardButtonDidTap() })
        )
        pasteboardItem.tintColor = .orangeMain
        pasteboardItem.accessibilityLabel = NSLocalizedString("Paste from clipboard", comment: "Add button accessibility label.")


        // MARK: Clear Text Button Item

        let customClearButton = UIButton(type: .custom)
        customClearButton.addAction(
            .init(handler: { [weak self] _ in self?.clearTextButtonDidTap() }),
            for: .touchUpInside
        )

        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 10.0
        configuration.baseForegroundColor = .redMain
        if #available(iOS 26.0, *) {
            configuration.image = UIImage(systemName: "pencil.slash", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        } else {
            configuration.image = UIImage(systemName: "pencil.slash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        }

        var container = AttributeContainer()
        container.font = Fonts.Poppins.medium(17.0).font
        configuration.attributedTitle = AttributedString(
            NSLocalizedString("Clear", comment: "Clear text button title."),
            attributes: container
        )

        customClearButton.configuration = configuration

        let clearTextItem = UIBarButtonItem(customView: customClearButton)
        if #available(iOS 26.0, *) {
            clearTextItem.sharesBackground = false
            clearTextItem.style = .prominent
        }
        clearTextItem.tintColor = .redLight
        clearTextItem.accessibilityLabel = NSLocalizedString("Clear text field", comment: "Add button accessibility label.")

        // MARK: Flexible Space Button Item

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        // MARK: Hide Keyboard Button Item

        let hideKeyboardItem = UIBarButtonItem(
            image: UIImage(systemName: "keyboard.chevron.compact.down", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)),
            primaryAction: .init(handler: { [weak self] _ in self?.hideKeyboardButtonDidTap() })
        )
        hideKeyboardItem.tintColor = .orangeMain
        hideKeyboardItem.accessibilityLabel = NSLocalizedString("Hide keyboard", comment: "Add button accessibility label.")

        toolbar.items = [pasteboardItem, clearTextItem, flexibleSpace, hideKeyboardItem]

        return toolbar
    }()

    private let pasteboardButtonDidTap: () -> ()
    private let clearTextButtonDidTap: () -> ()
    private let hideKeyboardButtonDidTap: () -> ()

    init(
        frame: CGRect,
        pasteboardButtonDidTap: @escaping () -> (),
        clearTextButtonDidTap: @escaping () -> (),
        hideKeyboardButtonDidTap: @escaping () -> ()
    ) {
        self.pasteboardButtonDidTap = pasteboardButtonDidTap
        self.clearTextButtonDidTap = clearTextButtonDidTap
        self.hideKeyboardButtonDidTap = hideKeyboardButtonDidTap

        let enlargedFrame = CGRect(
            x: frame.origin.x,
            y: frame.origin.y,
            width: frame.size.width,
            height: Constants.toolbarHeight + Constants.bottomPadding
        )

        super.init(frame: enlargedFrame, inputViewStyle: .keyboard)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear

        toolbar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(toolbar)

        NSLayoutConstraint.activate(
            [
                toolbar.topAnchor.constraint(equalTo: topAnchor),
                toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
                toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
                toolbar.heightAnchor.constraint(equalToConstant: Constants.toolbarHeight)
            ]
        )
    }
}
