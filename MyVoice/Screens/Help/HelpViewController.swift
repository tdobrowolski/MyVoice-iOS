//
//  HelpViewController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 14/03/2021.
//

import UIKit

// TODO: Remove old ViewController files

final class HelpViewController: BaseViewController<HelpViewModel> {
    @IBOutlet weak var speakPhrasesHelpView: UIView!
    @IBOutlet weak var speakPhrasesHelpTitleLabel: UILabel!
    @IBOutlet weak var speakPhrasesHelpContentLabel: UILabel!
    
    @IBOutlet weak var customizeSpeakHelpView: UIView!
    @IBOutlet weak var customizeSpeakHelpTitleLabel: UILabel!
    @IBOutlet weak var customizeSpeakHelpContentLabel: UILabel!
    
    @IBOutlet weak var changeVoiceHelpView: UIView!
    @IBOutlet weak var changeVoiceHelpTitleLabel: UILabel!
    @IBOutlet weak var changeVoiceHelpContentLabel: UILabel!
    
    @IBOutlet weak var downloadVoiceHelpView: UIView!
    @IBOutlet weak var downloadVoiceHelpTitleLabel: UILabel!
    @IBOutlet weak var downloadVoiceHelpContentLabel: UILabel!
    @IBOutlet weak var downloadVoiceHelp1stLabel: UILabel!
    @IBOutlet weak var downloadVoiceHelp2ndLabel: UILabel!
    @IBOutlet weak var downloadVoiceHelp3rdLabel: UILabel!
    @IBOutlet weak var downloadVoiceHelp4thLabel: UILabel!
    @IBOutlet weak var downloadVoiceHelpSummaryLabel: UILabel!
    @IBOutlet weak var downloadVoiceHelpLinkLabel: UILabel!
    
    @IBOutlet weak var quickAccessHelpView: UIView!
    @IBOutlet weak var quickAccessHelpTitleLabel: UILabel!
    @IBOutlet weak var quickAccessHelpContentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Help", comment: "Help")
        view.backgroundColor = .background
        setupHelpContent()
        addNavigationBarButtons()
    }
    
    // MARK: Setting up content
    
    private func setupHelpContent() {
        // First section
        speakPhrasesHelpTitleLabel.font = Fonts.Poppins.bold(20.0).font
        speakPhrasesHelpTitleLabel.text = NSLocalizedString("How to make my phrases be spoken out loud?", comment: "")
        speakPhrasesHelpContentLabel.font = Fonts.Poppins.medium(14.0).font
        speakPhrasesHelpContentLabel.text = NSLocalizedString("Enter the text, that you want to be spoken, into the main, upper text field on the MyVoice screen. When you are ready to hear your phrase, tap Speak button under the text field. If you don’t hear your text, try to change the volume of your device. You can always have a quick look at your volume level on Speak button. The speaker icon shows your current volume setting.", comment: "")

        // Second section
        customizeSpeakHelpTitleLabel.font = Fonts.Poppins.bold(20.0).font
        customizeSpeakHelpTitleLabel.text = NSLocalizedString("How to customize the way my phrases are spoken?", comment: "")
        customizeSpeakHelpContentLabel.font = Fonts.Poppins.medium(14.0).font
        customizeSpeakHelpContentLabel.text = NSLocalizedString("On the Settings screen, you can customize some options, that will affect how your text is spoken. With Speech rate slider, you choose how fast your phrases will be said out loud. Speech pitch slider will change voice pitch. Try to experiment with it in Settings and find the best options that will suit you. You can also change the voice with its language that will be responsible for speaking all texts.", comment: "")

        // Third section
        changeVoiceHelpTitleLabel.font = Fonts.Poppins.bold(20.0).font
        changeVoiceHelpTitleLabel.text = NSLocalizedString("How to change speaking voice and its language?", comment: "")
        changeVoiceHelpContentLabel.font = Fonts.Poppins.medium(14.0).font
        changeVoiceHelpContentLabel.text = NSLocalizedString("To change the voice that will speak your phrases, go to the Settings screen. Select the Speech voice setting. You will see a new screen with a list of all voices available on your device. Each voice has its properties with its language. Some voices are also available in Enhanced mode - that means your phrases will sound more natural and with better pronunciation.", comment: "")

        // Fourth section
        downloadVoiceHelpTitleLabel.font = Fonts.Poppins.bold(20.0).font
        downloadVoiceHelpTitleLabel.text = NSLocalizedString("How to download more voices?", comment: "")
        downloadVoiceHelpContentLabel.font = Fonts.Poppins.medium(14.0).font
        downloadVoiceHelpContentLabel.text = NSLocalizedString("You can always download a bunch of new voices with support for more languages. You can’t do that from the MyVoice app. To do that:", comment: "")

        var attributedString = NSMutableAttributedString(
            string: NSLocalizedString("1. Open the system", comment: "First part of bigger text"),
            attributes: [NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font]
        )
        var textToAttribute = NSMutableAttributedString(
            string: NSLocalizedString("Settings app", comment: "Second part of bigger text"),
            attributes: [NSAttributedString.Key.font: Fonts.Poppins.semibold(14.0).font]
        )
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(textToAttribute)
        attributedString.append(NSAttributedString(string: "."))
        downloadVoiceHelp1stLabel.attributedText = attributedString

        attributedString = NSMutableAttributedString(string: NSLocalizedString("2. Navigate to", comment: "First part of bigger text"), attributes: [NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font])
        textToAttribute = NSMutableAttributedString(string: NSLocalizedString("Accessibility > VoiceOver > Speech", comment: "Second part of bigger text"), attributes: [NSAttributedString.Key.font: Fonts.Poppins.semibold(14.0).font])
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(textToAttribute)
        attributedString.append(NSAttributedString(string: "."))
        downloadVoiceHelp2ndLabel.attributedText = attributedString

        attributedString = NSMutableAttributedString(string: NSLocalizedString("3. Tap on Add New Language and select the language/dialect that you want to add.", comment: ""), attributes: [NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font])
        var textRange = attributedString.mutableString.range(of: NSLocalizedString("Add New Language", comment: "Name for Settings app button"))
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        downloadVoiceHelp3rdLabel.attributedText = attributedString

        downloadVoiceHelp4thLabel.font = Fonts.Poppins.medium(14.0).font
        downloadVoiceHelp4thLabel.text = NSLocalizedString("4. Select an added language from the Speech screen and choose Default or Enhanced quality of your voice.", comment: "")

        downloadVoiceHelpSummaryLabel.font = Fonts.Poppins.medium(14.0).font
        downloadVoiceHelpSummaryLabel.text = NSLocalizedString("That’s it. If you go to MyVoice’s Select voice screen, you will see added voice on the list. You can now select it and all your phrases will be spoken with that voice.", comment: "")

        attributedString = NSMutableAttributedString(string: NSLocalizedString("Still lost? Go to the official Apple tutorial.", comment: ""), attributes: [NSAttributedString.Key.font: Fonts.Poppins.medium(14.0).font])
        textRange = attributedString.mutableString.range(of: NSLocalizedString("Go to the official Apple tutorial.", comment: ""))
        attributedString.addAttribute(NSAttributedString.Key.font, value: Fonts.Poppins.semibold(14.0).font, range: textRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orangeMain ?? .orange, range: textRange)
        downloadVoiceHelpLinkLabel.attributedText = attributedString

        let tapLinkGesture = UITapGestureRecognizer(target: self, action: #selector(appleHelpLinkDidTap))
        downloadVoiceHelpLinkLabel.addGestureRecognizer(tapLinkGesture)

        // Fifth section
        quickAccessHelpTitleLabel.font = Fonts.Poppins.bold(20.0).font
        quickAccessHelpTitleLabel.text = NSLocalizedString("What is Quick access?", comment: "")
        quickAccessHelpContentLabel.font = Fonts.Poppins.medium(14.0).font
        quickAccessHelpContentLabel.text = NSLocalizedString("Quick access list helps you reach your saved phrases very fast, so you don’t need to always type them when you want to speak them. Enter the phrase into the text field and tap Save button. The text will appear on the Quick access list. To say it loud, just touch it. If you want to remove it, swipe your finger on the phrase to the left.", comment: "")
    }
    
    @objc
    func appleHelpLinkDidTap() {
        guard let pageURL = viewModel.getVoiceOverHelpURL(prefferedLanguages: Bundle.main.preferredLocalizations) else { return }

        UIApplication.shared.open(pageURL)
    }
    
    // MARK: Navigation Bar items methods
    
    private func addNavigationBarButtons() {
        let font = Fonts.Poppins.semibold(17.0).font
        let color = UIColor.orangeMain ?? .orange
        
        let rightItem = UIBarButtonItem(
            title: NSLocalizedString("Done", comment: "Done"),
            style: .plain,
            target: self,
            action: #selector(doneDidTouch)
        )
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .normal)
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .selected)
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc
    private func doneDidTouch() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
