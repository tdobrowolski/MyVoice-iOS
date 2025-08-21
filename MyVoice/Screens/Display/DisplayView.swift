//
//  DisplayView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 20/08/2025.
//

import SwiftUI

struct DisplayView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background {
                UIColor.background?.asColor.ignoresSafeArea()
            }
    }

    private var content: some View {
        VStack(spacing: 8.0) {
            HStack(spacing: 0.0) {
                Spacer()
                closeButton
                    .padding(.horizontal, 16.0)
            }
            Text("Big Debug Test")
                .font(Fonts.Poppins.semibold(16.0).swiftUIFont)
                .padding(.horizontal, 16.0)
                .frame(maxHeight: .infinity, alignment: .center)
        }
        .padding(.vertical, 8.0)
    }

    @ViewBuilder
    private var closeButton: some View {
        if #available(iOS 26.0, *) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17.0, weight: .bold))
                    .foregroundColor(UIColor.whiteCustom?.asColor)
            }
            .frame(width: 40.0, height: 40.0)
            .glassEffect(
                .regular.tint(UIColor.orangeMain?.asColor).interactive(),
                in: Circle()
            )
        } else {
            Button {
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(UIColor.orangeLight?.asColor ?? .orange)
                        .frame(width: 40.0, height: 40.0)
                    Image(systemName: "xmark")
                        .font(.system(size: 17.0, weight: .bold))
                        .foregroundColor(UIColor.orangeMain?.asColor)
                }
            }
        }
    }
}

final class DisplayViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        let hostingController = UIHostingController(rootView: DisplayView())

        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    // TODO: Try to remove
    override var shouldAutorotate: Bool {
        return false
    }
}

// MARK: Claude code

class ClaudeDisplayViewController: UIViewController {
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

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    // TODO: Try to remove
    override var shouldAutorotate: Bool {
        return false
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
