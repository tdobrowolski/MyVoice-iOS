//
//  SettingsViewController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 27/01/2021.
//

import UIKit
import RxCocoa
import RxDataSources

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<SettingsSection>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        self.view.backgroundColor = UIColor(named: "Blue (Light)")
        self.addNavigationBarButtons()
        
        self.tableView.register(SliderTableViewCell.self, forCellReuseIdentifier: "sliderCell")
        self.tableView.delaysContentTouches = false
    }
    
    override func bindViewModel(viewModel: SettingsViewModel) {
        
        self.dataSource = self.getDataSourceForSettings()
        
        viewModel.sections.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // MARK: Setting data source
    
    func getDataSourceForSettings() -> RxTableViewSectionedAnimatedDataSource<SettingsSection> {
        return RxTableViewSectionedAnimatedDataSource<SettingsSection> (
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
        guard let sections = try? self.viewModel.sections.value() else { return UITableViewCell() }
        let sectionType = sections[indexPath.section].type
        
        switch sectionType {
        case .speechLanguage, .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "defaultCell")
            cell.textLabel?.text = sections[indexPath.section].items[indexPath.row].primaryText
            cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15)
            cell.textLabel?.textColor = UIColor(named: "Black)") ?? .black
            cell.detailTextLabel?.text = sections[indexPath.section].items[indexPath.row].secondaryText
            cell.detailTextLabel?.font = UIFont(name: "Poppins-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15)
            cell.detailTextLabel?.textColor = UIColor(named: "Blue (Dark)") ?? .gray
            cell.accessoryType = .disclosureIndicator
            return cell
        case .speechRate:
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell") as! SliderTableViewCell
            cell.setupSlider(for: .speechRate(currentValue: 1, minValue: 0, maxValue: 2)) // TODO: Pass real values
            return cell
        case .speechPitch:
            let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell") as! SliderTableViewCell
            cell.setupSlider(for: .speechPitch(currentValue: 1)) // TODO: Pass real value
            return cell
        }
    }
    
    private func getHeaderTitle(for section: Int) -> String? {
        guard let sections = try? viewModel.sections.value() else { return nil }
        return sections[section].type.rawValue
    }
    
    private func getFooterTitle(for section: Int) -> String? {
        guard let sections = try? viewModel.sections.value() else { return nil }
        return sections[section].footer
    }
    
    // MARK: Navigation Bar items methods
    
    private func addNavigationBarButtons() {
        let font = UIFont(name: "Poppins-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let color = UIColor(named: "Orange (Main)") ?? .orange
        
        let rightItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDidTouch))
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .normal)
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .selected)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc
    private func doneDidTouch() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Setup layout
    
    private func setupTableView() {
        
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.init(name: "Poppins-Medium", size: 13)
        header.textLabel?.textColor = UIColor(named: "Blue (Dark)")
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        footer.textLabel?.font = UIFont.init(name: "Poppins-Regular", size: 12)
        footer.textLabel?.textColor = UIColor(named: "Blue (Dark)")
    }
}
