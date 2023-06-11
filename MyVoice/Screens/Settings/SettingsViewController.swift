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
        
        tableView.register(
            UINib(nibName: Nib.sliderTableViewCell.name, bundle: nil),
            forCellReuseIdentifier: Nib.sliderTableViewCell.cellIdentifier
        )
        tableView.delaysContentTouches = false
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
        case .speechVoice, .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: Nib.defaultCell.cellIdentifier) ?? UITableViewCell(style: .value1, reuseIdentifier: Nib.defaultCell.cellIdentifier)
            cell.backgroundColor = .whiteCustom
            cell.textLabel?.text = sections[indexPath.section].items[indexPath.row].primaryText
            cell.textLabel?.font = Fonts.Poppins.medium(15.0).font
            cell.textLabel?.textColor = .blackCustom ?? .black
            cell.detailTextLabel?.text = sections[indexPath.section].items[indexPath.row].secondaryText
            cell.detailTextLabel?.font = Fonts.Poppins.regular(15.0).font
            cell.detailTextLabel?.textColor = .blueDark ?? .gray
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
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc
    private func doneDidTouch() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
        
    // MARK: Handle settings actions
    
    private func showLanguagePicker() {
        let languagePickerViewModel = LanguagePickerViewModel(delegate: self)
        let languagePickerViewController = LanguagePickerViewController(
            viewModel: languagePickerViewModel,
            nibName: Nib.languagePickerViewController.name
        )
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
