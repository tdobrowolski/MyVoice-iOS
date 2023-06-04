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
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<SettingsSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Settings", comment: "Settings")
        view.backgroundColor = .background
        addNavigationBarButtons()
        
        tableView.register(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "sliderCell")
        tableView.delaysContentTouches = false
    }
    
    override func bindViewModel(_ viewModel: SettingsViewModel) {
        
        self.dataSource = self.getDataSourceForSettings()
        
        viewModel.sections.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // MARK: Setting data source
    
    func getDataSourceForSettings() -> RxTableViewSectionedAnimatedDataSource<SettingsSection> {
        RxTableViewSectionedAnimatedDataSource<SettingsSection> (
            configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
                return self?.getCell(for: tableView, indexPath: indexPath, item: item) ?? UITableViewCell()
            },
            titleForHeaderInSection: { [weak self] dataSource, section in
                return self?.getHeaderTitle(for: section)
            },
            titleForFooterInSection: { [weak self] dataSource, section in
                return self?.getFooterTitle(for: section)
            }
        )
    }
    
    private func getCell(for tableView: UITableView, indexPath: IndexPath, item: SettingModel) -> UITableViewCell {
        guard let sections = try? viewModel.sections.value() else { return UITableViewCell() }

        let sectionType = sections[indexPath.section].type
        
        switch sectionType {
        case .speechVoice, .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "defaultCell")
            cell.backgroundColor = .whiteCustom
            cell.textLabel?.text = sections[indexPath.section].items[indexPath.row].primaryText
            cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15)
            cell.textLabel?.textColor = .blackCustom ?? .black
            cell.detailTextLabel?.text = sections[indexPath.section].items[indexPath.row].secondaryText
            cell.detailTextLabel?.font = UIFont(name: "Poppins-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)
            cell.detailTextLabel?.textColor = .blueDark ?? .gray
            cell.accessoryType = .disclosureIndicator

            return cell

        case .speechRate:
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell") as! SliderTableViewCell
            cell.backgroundColor = .whiteCustom
            cell.setupSlider(for: self.viewModel.getDataTypeForSpeechRate())
            cell.defaultSlider.rx.value.skip(1).subscribe { [weak self] value in
                self?.viewModel.setSpeechRate(value)
            }.disposed(by: cell.disposeBag)

            return cell

        case .speechPitch:
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell") as! SliderTableViewCell
            cell.backgroundColor = .whiteCustom
            cell.setupSlider(for: self.viewModel.getDataTypeForSpeechPitch())
            cell.defaultSlider.rx.value.skip(1).subscribe { [weak self] value in
                self?.viewModel.setSpeechPitch(value)
            }.disposed(by: cell.disposeBag)

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
        let font = UIFont(name: "Poppins-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let color = UIColor.orangeMain ?? .orange
        
        let rightItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Done"), style: .plain, target: self, action: #selector(doneDidTouch))
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
    
    // MARK: Setup layout
    
    private func setupTableView() {
        // TODO: Remove if not needed
    }
    
    // MARK: Handle settings actions
    
    private func showLanguagePicker() {
        let languagePickerViewModel = LanguagePickerViewModel(delegate: self)
        let languagePickerViewController = LanguagePickerViewController(viewModel: languagePickerViewModel, nibName: "LanguagePickerViewController")
        let languagePickerNavigationController = DefaultNavigationController(rootViewController: languagePickerViewController)

        present(languagePickerNavigationController, animated: true, completion: nil)
    }
    
    private func openAppStoreForReview() {
        guard let writeReviewURL = URL(string: "") else { return }

        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
    private func composeFeedbackMail() {
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setToRecipients(["infinity.tobiasz.dobrowolski@gmail.com"])

        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            mailViewController.setSubject("MyVoice App (\(appVersion)) - Feedback")
        } else {
            mailViewController.setSubject("MyVoice App - Feedback")
        }

        present(mailViewController, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let sections = try? viewModel.sections.value() else { return nil }

        let sectionType = sections[indexPath.section].type
        
        switch sectionType {
        case .speechVoice, .other: return indexPath
        case .speechRate, .speechPitch: return nil
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sections = try? viewModel.sections.value() else { return }

        let sectionType = sections[indexPath.section].type
        
        switch sectionType {
        case .speechVoice:
            showLanguagePicker()

        case .speechRate, .speechPitch:
            return

        case .other:
            switch indexPath.row {
            case 0:
//                self.openAppStoreForReview()
                fallthrough
                // TODO: If review available, remove fallthrough
                
            case 1:
                if MFMailComposeViewController.canSendMail() {
                    composeFeedbackMail()
                } else {
                    showAlert(title: NSLocalizedString("No mail account", comment: "No mail account"),
                              message: NSLocalizedString("It looks like there's no mail account, that the system can use to send feedback.",
                                                         comment: "It looks like there's no mail account, that the system can use to send feedback."),
                              actions: [UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)])
                }

            default:
                return
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }

        header.textLabel?.font = UIFont.init(name: "Poppins-Medium", size: 13)
        header.textLabel?.textColor = .blueDark
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        36
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }

        footer.textLabel?.font = UIFont.init(name: "Poppins-Regular", size: 12)
        footer.textLabel?.textColor = .blueDark
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: VoiceSelectedDelegate {
    func userSelectedVoice() {
        viewModel.refreshSelectedVoiceLabel()
    }
}
