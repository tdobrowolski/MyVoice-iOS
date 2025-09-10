//
//  SettingsViewController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 27/01/2021.
//

import UIKit
import RxCocoa
import RxDataSources
import MessageUI

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    private enum FeedbackConstants {
        static var mail: String { "infinity.tobiasz.dobrowolski@gmail.com" }
        
        static private var mailTo: String? {
            "mailto:\(mail)?subject=\(subject)"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        
        static var mailToUrl: URL? {
            guard let mailTo else { return nil }
            
            return URL(string: mailTo)
        }
        
        static var subject: String {
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
                return "MyVoice App (\(appVersion)) - Feedback"
            } else {
                return "MyVoice App - Feedback"
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<SettingsSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Settings", comment: "Settings")
        view.backgroundColor = .background
        addNavigationBarButtons()
        
        tableView.register(
            UINib(nibName: Nib.sliderTableViewCell.name, bundle: nil),
            forCellReuseIdentifier: Nib.sliderTableViewCell.cellIdentifier
        )
        tableView.register(
            UINib(nibName: Nib.switchTableViewCell.name, bundle: nil),
            forCellReuseIdentifier: Nib.switchTableViewCell.cellIdentifier
        )
        tableView.delaysContentTouches = false
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    override func bindViewModel(_ viewModel: SettingsViewModel) {
        dataSource = self.getDataSourceForSettings()
        
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    @objc
    private func didEnterForeground() {
        viewModel.onEnterForeground()
    }
    
    // MARK: Setting data source
    
    func getDataSourceForSettings() -> RxTableViewSectionedAnimatedDataSource<SettingsSection> {
        RxTableViewSectionedAnimatedDataSource<SettingsSection> (
            configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
                self?.getCell(for: tableView, indexPath: indexPath, item: item) ?? UITableViewCell()
            },
            titleForHeaderInSection: { [weak self] dataSource, section in
                self?.getHeaderTitle(for: section)
            },
            titleForFooterInSection: { [weak self] dataSource, section in
                self?.getFooterTitle(for: section)
            }
        )
    }
    
    private func getCell(for tableView: UITableView, indexPath: IndexPath, item: SettingModel) -> UITableViewCell {
        guard let sections = try? viewModel.sections.value() else { return UITableViewCell() }
        
        let sectionType = sections[indexPath.section].type
        
        switch sectionType {
        case .speechVoice, .personalVoice, .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: Nib.defaultCell.cellIdentifier) ?? UITableViewCell(style: .value1, reuseIdentifier: Nib.defaultCell.cellIdentifier)
            cell.backgroundColor = .whiteCustom
            cell.textLabel?.text = sections[indexPath.section].items[indexPath.row].primaryText
            cell.textLabel?.font = Fonts.Poppins.medium(15.0).font
            cell.textLabel?.textColor = .blackCustom ?? .black
            cell.textLabel?.minimumScaleFactor = 0.9
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.allowsDefaultTighteningForTruncation = true
            cell.detailTextLabel?.text = sections[indexPath.section].items[indexPath.row].secondaryText
            cell.detailTextLabel?.font = Fonts.Poppins.regular(15.0).font
            cell.detailTextLabel?.textColor = .blueDark ?? .gray
            cell.detailTextLabel?.allowsDefaultTighteningForTruncation = true
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        case .speechRate:
            let cell = tableView.dequeueReusableCell(withIdentifier: Nib.sliderTableViewCell.cellIdentifier) as! SliderTableViewCell
            cell.backgroundColor = .whiteCustom
            cell.setupSlider(for: viewModel.getDataTypeForSpeechRate())
            cell.defaultSlider.rx.value
                .skip(1)
                .subscribe { [weak self] value in
                    var finalValue: Float
                    
                    if SliderDataType.defaultAdjustmentRateRange.contains(value) {
                        finalValue = SliderDataType.defaultSpeechRateValue
                        cell.adjustSlider(for: finalValue)
                        self?.viewModel.didSetSliderToCenter()
                    } else {
                        finalValue = value
                    }
                    
                    self?.viewModel.setSpeechRate(finalValue)
                }
                .disposed(by: cell.disposeBag)



            return cell
            
        case .speechPitch:
            let cell = tableView.dequeueReusableCell(withIdentifier: Nib.sliderTableViewCell.cellIdentifier) as! SliderTableViewCell
            cell.backgroundColor = .whiteCustom
            cell.setupSlider(for: viewModel.getDataTypeForSpeechPitch())
            cell.defaultSlider.rx.value
                .skip(1)
                .subscribe { [weak self] value in
                    var finalValue: Float
                    
                    if SliderDataType.defaultAdjustmentPitchRange.contains(value) {
                        finalValue = SliderDataType.defaultSpeechPitchValue
                        cell.adjustSlider(for: finalValue)
                        self?.viewModel.didSetSliderToCenter()
                    } else {
                        finalValue = value
                    }
                    
                    self?.viewModel.setSpeechPitch(finalValue)
                }
                .disposed(by: cell.disposeBag)
            
            return cell

        case .accessibility:
            let cell = tableView.dequeueReusableCell(withIdentifier: Nib.switchTableViewCell.cellIdentifier) as! SwitchTableViewCell
            cell.setupCell(
                text: sections[indexPath.section].items[indexPath.row].primaryText,
                isOn: (try? viewModel.isAppAudioForCallsEnabled.value()) ?? false
            )

            // TODO: Debug if no infinite loop occurs
            // TODO: Check if initial value is set properly

            cell.switch.rx.controlEvent(.valueChanged)
                .withLatestFrom(cell.switch.rx.value)
                .subscribe { [weak self] isOn in
                    print("switch .valueChanged to \(isOn)")
                    Task {
                        let result = await self?.viewModel.setAppAudioForCalls(for: isOn)
                        if let error = result?.asError {
                            self?.handleAppAudioToCallsError(for: error)
                        }
                    }
                }
                .disposed(by: cell.disposeBag)

            cell.switch.rx.isOn
                .bind(to: viewModel.isAppAudioForCallsEnabled)
                .disposed(by: cell.disposeBag)

            viewModel.isAppAudioForCallsEnabled
                .subscribe { [weak self] isOn in
                    print("viewModel.isAppAudioForCallsEnabled .valueChanged to \(isOn)")
                }
                .disposed(by: cell.disposeBag)

            return cell
        }
    }
    
    private func getHeaderTitle(for section: Int) -> String? {
        guard let sections = try? viewModel.sections.value() else { return nil }
        
        return sections[section].localizedHeaderString
    }
    
    private func getFooterTitle(for section: Int) -> String? {
        guard let sections = try? viewModel.sections.value() else { return nil }
        
        return sections[section].footer
    }
    
    // MARK: Navigation Bar items methods
    
    private func addNavigationBarButtons() {
        let font = Fonts.Poppins.semibold(17.0).font
        let color = UIColor.orangeMain ?? .orange
        
        let rightItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Done"), style: .plain, target: self, action: #selector(doneDidTouch))
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .normal)
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .selected)
        rightItem.accessibilityLabel = NSLocalizedString("Close settings", comment: "Close settings")
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc
    private func doneDidTouch() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
        
    // MARK: Handle settings actions
    
    private func showLanguagePicker() {
        let languagePickerViewModel = LanguagePickerViewModel(
            personalVoiceService: viewModel.personalVoiceService,
            delegate: self
        )
        let languagePickerViewController = LanguagePickerViewController(
            viewModel: languagePickerViewModel,
            nibName: Nib.languagePickerViewController.name
        )
        let languagePickerNavigationController = DefaultNavigationController(rootViewController: languagePickerViewController)
        
        present(languagePickerNavigationController, animated: true, completion: nil)
    }
    
    private func handlePersonalVoiceStatusAction() {
        guard let status = try? viewModel.personalVoiceAuthorizationStatus.value() else { return }
        
        switch status {
        case .notDetermined: 
            if #available(iOS 17.0, *) {
                Task {
                    await viewModel.requestPersonalVoiceAccess()
                    tableView.reloadData()
                }
            } else {
                fallthrough
            }
            
        default:
            var actions = [
                UIAlertAction(
                title: NSLocalizedString("OK", comment: "OK"),
                style: .default,
                handler: nil
                )
            ]
            if status == .denied {
                actions.insert(
                    UIAlertAction(
                        title: NSLocalizedString("Learn more", comment: ""),
                        style: .default,
                        handler: { [weak self] _ in self?.learnMoreDidTap() }
                    ),
                    at: 0
                )
            }

            showAlert(title: status.title,
                      message: status.settingsAlertMessage,
                      actions: actions)
        }
    }

    private func learnMoreDidTap() {
        let helpViewModel = HelpViewModel(
            supportsPersonalVoice: true,
            onDone: { [weak self] in self?.dismiss(animated: true) }
        )
        let helpViewController = HelpView(
            viewModel: helpViewModel,
            contentTypeToExpand: .personalVoice
        ).asViewController
        let helpNavigationController = DefaultNavigationController(rootViewController: helpViewController)

        present(helpNavigationController, animated: true, completion: nil)
    }

    private func openAppStoreForReview() {
        guard let writeReviewURL = URL(string: "itms-apps:itunes.apple.com/app/6450155201"), UIApplication.shared.canOpenURL(writeReviewURL) else {
            return showAlert(title: NSLocalizedString("Can't open App Store", comment: ""),
                      message: NSLocalizedString("Looks like we have some problems with opening the App Store. Our team of trained monkeys is working hard to fix this. You can still leave a review by sending feedback.",
                                                 comment: ""),
                      actions: [UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)])
        }
        
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
    private func openFeedbackMail() {
        if MFMailComposeViewController.canSendMail() {
            handleMFMailComposeFeedback()
        } else if let mailToUrl = FeedbackConstants.mailToUrl,
                    UIApplication.shared.canOpenURL(mailToUrl) {
            handleMailToFeedback(for: mailToUrl)
        } else {
            showAlert(
                title: NSLocalizedString("No mail account", comment: "No mail account"),
                message: NSLocalizedString("It looks like there's no mail account, that the system can use to send feedback.",
                                           comment: "It looks like there's no mail account, that the system can use to send feedback."),
                actions: [UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)]
            )
        }
    }

    private func handleAppAudioToCallsError(for error: AppAudioForCallsError) {
        var actions: [UIAlertAction] = []

        if error.canNavigateToSystemSettings {
            actions = [
                UIAlertAction(
                    title: NSLocalizedString("Open Settings", comment: ""),
                    style: .default,
                    handler: { [weak self] _ in
                        if #available(iOS 18.2, *) {
                            Task { await self?.viewModel.navigateToAccessibilitySettings(for: .allowAppsToAddAudioToCalls) }
                        }
                    }
                )
            ]
        } else {
            actions = [UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)]
        }

        showAlert(
            title: error.title,
            message: error.message,
            actions: actions
        )
    }

    private func handleMFMailComposeFeedback() {
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setToRecipients([FeedbackConstants.mail])
        mailViewController.setSubject(FeedbackConstants.subject)
        
        present(mailViewController, animated: true)
    }
    
    private func handleMailToFeedback(for mailToUrl: URL) {
        UIApplication.shared.open(mailToUrl)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let sections = try? viewModel.sections.value() else { return nil }
        
        let sectionType = sections[indexPath.section].type
        
        switch sectionType {
        case .speechVoice, .personalVoice, .other: return indexPath
        case .speechRate, .speechPitch, .accessibility: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sections = try? viewModel.sections.value() else { return }
        
        let sectionType = sections[indexPath.section].type
        
        switch sectionType {
        case .speechVoice:
            showLanguagePicker()
            
        case .speechRate, .speechPitch, .accessibility:
            return
            
        case .personalVoice:
            handlePersonalVoiceStatusAction()

        case .other:
            switch indexPath.row {
            case 0: openAppStoreForReview()
            case 1: openFeedbackMail()
            default: return
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = Fonts.Poppins.medium(13.0).font
        header.textLabel?.textColor = .blueDark
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 36.0 }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        
        footer.textLabel?.font = Fonts.Poppins.regular(12.0).font
        footer.textLabel?.textColor = .blueDark
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: VoiceSelectionDelegate {
    func didSelectVoice() {
        viewModel.refreshSelectedVoiceLabel()
    }
}
