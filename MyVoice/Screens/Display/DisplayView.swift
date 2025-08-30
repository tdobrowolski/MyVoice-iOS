//
//  DisplayView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 20/08/2025.
//

import SwiftUI

// TODO: Force landscape orientation lock

class DisplayViewController: UIViewController {
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)

        let config = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .bold)
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(xmarkImage, for: .normal)

        button.layer.cornerRadius = 20.0
        button.layer.masksToBounds = true

        if #available(iOS 26.0, *) {
            button.configuration = .prominentGlass()
            button.tintColor = .orangeMain
        } else {
            button.tintColor = .orangeMain
            button.backgroundColor = .orangeLight
        }

        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true

        return button
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Fonts.Poppins.semibold(144.0).font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.textColor = .blackCustom
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let text: String

    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }

    private func setupUI() {
        view.backgroundColor = .background

        view.addSubview(closeButton)
        view.addSubview(textLabel)

        textLabel.text = text
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),

            textLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8.0),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            textLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0)
        ])
    }

    private func setupActions() {
        closeButton.addAction(
            .init(handler: { [weak self] _ in self?.dismiss(animated: true, completion: nil) } ),
            for: .touchUpInside
        )
    }
}
