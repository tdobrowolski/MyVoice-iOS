//
//  Help.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/10/2023.
//

import SwiftUI

struct Help: View {
    @State private var expandedType: HelpContentType?
    
    private let types = HelpContentType.allCases
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        content
            .navigationTitle(NSLocalizedString("Help", comment: "Help"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { doneButton }
            }
            .background(
                UIColor.background?.asColor.ignoresSafeArea()
            )
    }
    
    private var content: some View {
        ScrollViewReader { proxy in
            ScrollView {
                getList(proxy)
                    .padding(.horizontal, 16.0)
                    .padding(.bottom, 16.0)
            }
        }
    }
    
    private func getList(_ scrollViewProxy: ScrollViewProxy) -> some View {
        VStack(spacing: 16.0) {
            ForEach(types) { type in
                CollapsableHelpView(
                    contentType: type,
                    onTap: { id in
                        withAnimation(.bouncy) {
                            scrollViewProxy.scrollTo(id, anchor: .top)
                        }
                    },
                    isExpanded: .init(
                        get: {
                            expandedType == type
                        }, set: { isExpanded in
                            if isExpanded {
                                expandedType = type
                            } else {
                                expandedType = nil
                            }
                        }
                    )
                )
                .id(type.id)
            }
        }
    }
    
    private var doneButton: some View {
        Button(NSLocalizedString("Done", comment: "Done")) {
            presentationMode.wrappedValue.dismiss()
        }
        .font(Fonts.Poppins.semibold(17.0).swiftUIFont)
        .foregroundColor(UIColor.orangeMain?.asColor ?? .orange)
    }
}

#Preview {
    Help()
}

// TODO: Move

extension UIColor {
    var asColor: Color {
        Color(self)
    }
}

// TODO: Move

struct CollapsableHelpView: View {
    let contentType: HelpContentType
    let onTap: (String) -> Void
    
    @Binding var isExpanded: Bool
    
    var body: some View {
        content
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            primaryHeader
                .contentShape(Rectangle())
                .onTapGesture {
                    isExpanded.toggle()
                    onTap(contentType.id)
                }
            if isExpanded {
                secondaryContent
            }
        }
        .padding(16.0)
        .background(containerBox)
        .animation(.bouncy)
    }
    
    private var primaryHeader: some View {
        HStack(spacing: 16.0) {
            Text(contentType.primaryTitle)
                .foregroundColor(UIColor.blackCustom?.asColor)
                .font(Fonts.Poppins.bold(18.0).swiftUIFont)
                .multilineTextAlignment(.leading)
            Spacer()
            chevronIcon
        }
    }
    
    private var chevronIcon: some View {
        ZStack {
            Circle()
                .fill(UIColor.blueLight?.asColor ?? .white)
                .frame(width: 40.0, height: 40.0)
            Image(systemName: "chevron.right")
                .font(.system(size: 17.0, weight: .bold))
        }
        .rotationEffect(isExpanded ? .degrees(90.0) : .zero)
    }
    
    private var secondaryContent: some View {
        if #available(iOS 15, *) {
            Text(AttributedString(contentType.secondaryText))
                .font(Fonts.Poppins.medium(14.0).swiftUIFont)
                .multilineTextAlignment(.leading)
                .lineSpacing(1.0)
        } else {
            Text(contentType.secondaryText.string) // TODO: Handle iOS 14
                .font(Fonts.Poppins.medium(14.0).swiftUIFont)
                .multilineTextAlignment(.leading)
                .lineSpacing(1.0)
        }
    }
    
    private var containerBox: some View {
        RoundedRectangle(cornerRadius: 16.0)
            .fill(UIColor.whiteCustom?.asColor ?? .white)
    }
}

// TODO: Move

enum HelpContentType: String, CaseIterable, Identifiable {
    case speakPhrases
    case customizeSpeak
    case changeVoice
    case downloadVoice
    case quickAccess
    
    var id: String { rawValue }
    
    var primaryTitle: String {
        switch self {
        case .speakPhrases:
            return NSLocalizedString("How to make my phrases be spoken out loud?", comment: "")
            
        case .customizeSpeak:
            return NSLocalizedString("How to customize the way my phrases are spoken?", comment: "")
            
        case .changeVoice:
            return NSLocalizedString("How to change speaking voice and its language?", comment: "")
            
        case .downloadVoice:
            return NSLocalizedString("How to download more voices?", comment: "")
            
        case .quickAccess:
            return NSLocalizedString("What is Quick access?", comment: "")
        }
    }
    
    var secondaryText: NSAttributedString {
        switch self {
        case .speakPhrases:
            return getSpeakPhrasesContentText()
            
        case .customizeSpeak:
            return getCustomizeSpeakContentText()
            
        case .changeVoice:
            return getChangeVoiceContentText()
            
        case .downloadVoice:
            return getDownloadVoiceContentText()
            
        case .quickAccess:
            return getQuickAccessContentText()
        }
    }
    
    // MARK: Speak Phrases
    
    private func getSpeakPhrasesContentText() -> NSAttributedString {
        let string = NSLocalizedString("Enter the text, that you want to be spoken, into the main, upper text field on the MyVoice screen. When you are ready to hear your phrase, tap Speak button under the text field. If you don’t hear your text, try to change the volume of your device. You can always have a quick look at your volume level on Speak button. The speaker icon shows your current volume setting.", comment: "")
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: (UIColor.blackCustom ?? .black).withAlphaComponent(0.8),
            NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: Customize Speak
    
    private func getCustomizeSpeakContentText() -> NSAttributedString {
        let string = NSLocalizedString("On the Settings screen, you can customize some options, that will affect how your text is spoken. With Speech rate slider, you choose how fast your phrases will be said out loud. Speech pitch slider will change voice pitch. Try to experiment with it in Settings and find the best options that will suit you. You can also change the voice with its language that will be responsible for speaking all texts.", comment: "")
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: (UIColor.blackCustom ?? .black).withAlphaComponent(0.8),
            NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: Change Voice
    
    private func getChangeVoiceContentText() -> NSAttributedString {
        let string = NSLocalizedString("To change the voice that will speak your phrases, go to the Settings screen. Select the Speech voice setting. You will see a new screen with a list of all voices available on your device. Each voice has its properties with its language. Some voices are also available in Enhanced mode - that means your phrases will sound more natural and with better pronunciation.", comment: "")
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: (UIColor.blackCustom ?? .black).withAlphaComponent(0.8),
            NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: Download Voice
    
    private func getDownloadVoiceContentText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: NSLocalizedString("You can always download a bunch of new voices with support for more languages. You can’t do that from the MyVoice app. To do that:", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: (UIColor.blackCustom ?? .black).withAlphaComponent(0.8),
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        
        attributedString.append(.init(string: "\n\n"))
        
        let firstStep = NSMutableAttributedString(
            string: NSLocalizedString("1. Open the system", comment: "First part of bigger text"),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.blackCustom ?? .black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        var textToAttribute = NSMutableAttributedString(
            string: NSLocalizedString("Settings app", comment: "Second part of bigger text"),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.blackCustom ?? .black,
                NSAttributedString.Key.font: Fonts.Poppins.semibold(14.0).font
            ]
        )
        firstStep.append(NSAttributedString(string: " "))
        firstStep.append(textToAttribute)
        firstStep.append(NSAttributedString(string: "."))
        attributedString.append(firstStep)
        
        attributedString.append(.init(string: "\n\n"))

        let secondStep = NSMutableAttributedString(
            string: NSLocalizedString("2. Navigate to", comment: "First part of bigger text"),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.blackCustom ?? .black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        textToAttribute = NSMutableAttributedString(
            string: NSLocalizedString("Accessibility > VoiceOver > Speech", comment: "Second part of bigger text"),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.blackCustom ?? .black,
                NSAttributedString.Key.font: Fonts.Poppins.semibold(14.0).font
            ]
        )
        secondStep.append(NSAttributedString(string: " "))
        secondStep.append(textToAttribute)
        secondStep.append(NSAttributedString(string: "."))
        attributedString.append(secondStep)
        
        attributedString.append(.init(string: "\n\n"))

        let thirdStep = NSMutableAttributedString(
            string: NSLocalizedString("3. Tap on Add New Language and select the language/dialect that you want to add.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.blackCustom ?? .black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        var textRange = thirdStep.mutableString.range(of: NSLocalizedString("Add New Language", comment: "Name for Settings app button"))
        thirdStep.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        attributedString.append(thirdStep)
        
        attributedString.append(.init(string: "\n\n"))

        let fourthStep = NSMutableAttributedString(
            string: NSLocalizedString("4. Select an added language from the Speech screen and choose Default or Enhanced quality of your voice.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.blackCustom ?? .black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        attributedString.append(fourthStep)
        
        attributedString.append(.init(string: "\n\n"))

        let fourthStepSummary = NSMutableAttributedString(
            string: NSLocalizedString("That’s it. If you go to MyVoice’s Select voice screen, you will see added voice on the list. You can now select it and all your phrases will be spoken with that voice.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: (UIColor.blackCustom ?? .black).withAlphaComponent(0.8),
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        attributedString.append(fourthStepSummary)
        
        attributedString.append(.init(string: "\n\n"))

        let stillLost = NSMutableAttributedString(
            string: NSLocalizedString("Still lost? Go to the official Apple tutorial.", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.blackCustom ?? .black,
                NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
            ]
        )
        textRange = stillLost.mutableString.range(of: NSLocalizedString("Go to the official Apple tutorial.", comment: ""))
        stillLost.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        stillLost.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orangeMain ?? .orange, range: textRange)
        attributedString.append(stillLost)
        
        return attributedString
    }
    
    // MARK: Quick Access
    
    private func getQuickAccessContentText() -> NSAttributedString {
        let string = NSLocalizedString("Quick access list helps you reach your saved phrases very fast, so you don’t need to always type them when you want to speak them. Enter the phrase into the text field and tap Save button. The text will appear on the Quick access list. To say it loud, just touch it. If you want to remove it, swipe your finger on the phrase to the left.", comment: "")
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: (UIColor.blackCustom ?? .black).withAlphaComponent(0.8),
            NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }
}

import UIKit

extension View {
    var asViewController: UIViewController {
        UIHostingController(rootView: self)
    }
}

// TODO: Move
/*
final class ViewController<Content>: UIHostingController<Content>, ViewControllerProtocol where Content: View {
    let style: ViewControllerStyle

    var customNavigationBar: UIView? {
        view.subviews
            .first(where: { ($0 as? NavigationBar) != nil })
    }

    init(rootView: Content, style: ViewControllerStyle) {
        self.style = style

        super.init(rootView: rootView)

        if case .titled(let title) = style {
            self.title = title
        } else if case .titledClosable(let title, _) = style {
            self.title = title

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: R.image.iconX(),
                style: .plain,
                target: self,
                action: #selector(onClose)
            )
        }
    }

    @objc private func onClose() {
        if case .titledClosable(_, let onClose) = style {
            onClose()
        }
    }

    @MainActor
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/
