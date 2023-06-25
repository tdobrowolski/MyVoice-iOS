//
//  LanguagePickerViewController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 06/02/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import AVFAudio

final class LanguagePickerViewController: BaseViewController<LanguagePickerViewModel> {
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var searchController = UISearchController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Select voice", comment: "Select voice")
        view.backgroundColor = .background
        tableView.backgroundColor = .clear
        addSearchController()
        addNavigationBarButton()
    }
    
    override func bindViewModel(_ viewModel: LanguagePickerViewModel) {
        super.bindViewModel(viewModel)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.register(
            UINib(nibName: Nib.voiceTableViewCell.name, bundle: nil),
            forCellReuseIdentifier: Nib.voiceTableViewCell.cellIdentifier
        )
        
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: getDataSource()))
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(AVSpeechSynthesisVoice.self))
            .bind { [weak self] in self?.didSelectRowFor(indexPath: $0.0, identifier: $0.1.identifier) }
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [weak self] in self?.viewModel.didEnterSearchTerm($0) }
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(viewWillLayoutSubviews))
            .take(1)
            .subscribe { [weak self] _ in
                guard let identifier = viewModel.selectedLanguageIdentifier,
                      let indexPath = self?.viewModel.firstIndexPath(for: identifier) else {
                    return
                }

                self?.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
            .disposed(by: disposeBag)
    }
    
    private func getDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, AVSpeechSynthesisVoice>> {
        .init(
            configureCell: { [weak self] _, tableView, indexPath, element in
                guard let self,
                      let sections = try? self.viewModel.sections.value(),
                      let cell = tableView.dequeueReusableCell(withIdentifier: Nib.voiceTableViewCell.cellIdentifier) as? VoiceTableViewCell else {
                    return .init()
                }
                
                let numberOfItemsInSection = sections[indexPath.section].items.count
                let isLastInSection = indexPath.row + 1 == numberOfItemsInSection
                let isSelected = element.identifier == self.viewModel.selectedLanguageIdentifier
                
                cell.setupCell(
                    voiceName: element.name,
                    voiceQuality: element.quality,
                    voiceGender: element.gender,
                    isLastInSection: isLastInSection,
                    isSelected: isSelected
                )
                
                return cell
            },
            titleForHeaderInSection: { dataSource, section in dataSource[section].model }
        )
    }
    
    // MARK: Navigation items methods
    
    private func addSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let font = Fonts.Poppins.medium(14.0).font
        let attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("Search", comment: ""),
            attributes: [.font: font]
        )
        
        searchController.searchBar.searchTextField.font = font
        searchController.searchBar.searchTextField.attributedPlaceholder = attributedPlaceholder
        searchController.searchBar.tintColor = .orangeMain
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.orangeMain ?? .orange,
            .font: Fonts.Poppins.semibold(17.0).font
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func addNavigationBarButton() {
        let font = Fonts.Poppins.semibold(17.0).font
        let color = UIColor.orangeMain ?? .orange
        
        let rightItem = UIBarButtonItem(
            title: NSLocalizedString("Done", comment: "Done"),
            style: .plain,
            target: self,
            action: #selector(doneDidTouch)
        )
        rightItem.setTitleTextAttributes(
            [NSAttributedString.Key.font: font,
             NSAttributedString.Key.foregroundColor: color],
            for: .normal
        )
        rightItem.setTitleTextAttributes(
            [NSAttributedString.Key.font: font,
             NSAttributedString.Key.foregroundColor: color],
            for: .selected
        )
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc
    private func doneDidTouch() { dismiss(animated: true, completion: nil) }

    private func didSelectRowFor(indexPath: IndexPath, identifier: String) {
        if let previousSelectedIdentifier = viewModel.selectedLanguageIdentifier,
           previousSelectedIdentifier != identifier,
           let previouseSelectedIndexPath = viewModel.firstIndexPath(for: previousSelectedIdentifier) {
            let previousSelectedCell = tableView.cellForRow(at: previouseSelectedIndexPath) as? VoiceTableViewCell
            previousSelectedCell?.checkmarkImageView.isHidden = true
        }
        
        viewModel.selectedLanguageIdentifier = identifier
        
        let cell = tableView.cellForRow(at: indexPath) as? VoiceTableViewCell
        cell?.checkmarkImageView.isHidden = false
        
        viewModel.selectVoice(for: identifier)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LanguagePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionTitle = try? viewModel.sections.value()[section].model else { return nil }

        let view = HeaderView()
        view.label.text = sectionTitle

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 32.0 }
}
