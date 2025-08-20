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
            .rotationEffect(.degrees(90.0))
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
//                .frame(maxHeight: .infinity, alignment: .center)
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
        hostingController.view.backgroundColor = .clear

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

    override var shouldAutorotate: Bool {
        return false
    }
}
