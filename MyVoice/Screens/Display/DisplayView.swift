//
//  DisplayView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 20/08/2025.
//

import SwiftUI

class DisplayViewController: UIViewController {
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Fonts.Poppins.semibold(144.0).font
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.minimumScaleFactor = 0.1
        label.textColor = .blackCustom
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let text: String

    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)

        OrientationManager.shared.type = System.displayTextOrientation
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarButtons()
        setupUI()
        setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        OrientationManager.shared.type = System.defaultOrientation
        super.viewWillDisappear(animated)
    }

    private func addNavigationBarButtons() {
        let color = UIColor.orangeMain ?? .orange

        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let xmarkImage = UIImage(
            systemName: "xmark",
            withConfiguration: configuration
        )
        let rightItem = UIBarButtonItem(
            title: nil,
            image: xmarkImage,
            primaryAction: .init(handler: { [weak self] _ in self?.onCloseTap() }),
            menu: nil
        )
        rightItem.tintColor = color
        rightItem.accessibilityLabel = NSLocalizedString("Close display screen", comment: "")
        navigationItem.rightBarButtonItem = rightItem
    }

    private func setupUI() {
        view.backgroundColor = .background
        view.addSubview(textLabel)
        textLabel.text = text
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            textLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32.0)
        ])
    }

    private func onCloseTap() {
        OrientationManager.shared.type = System.defaultOrientation
        dismiss(animated: true, completion: nil)
    }
}
