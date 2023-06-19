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
    
    // TODO: Move to ViewModel and initialize
//    private let selectedLanguageIdentifierSubject = BehaviorSubject<String?>(value: nil)
//    private var selectedLanguageIdentifier: String? {
//        get { try? selectedLanguageIdentifierSubject.value() }
//        set { selectedLanguageIdentifierSubject.onNext(newValue) }
//    }
    
    // TODO: Clean up
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
        
//        viewModel.voices
//            .bind(to: tableView.rx.items(dataSource: getDataSource()))
//            .disposed(by: disposeBag)
        
//        tableView.rx.itemSelected
//            .subscribe { [weak self] in self?.didSelectRowAt($0) }
//            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(AVSpeechSynthesisVoice.self))
            .bind { [weak self] in self?.didSelectRowFor(indexPath: $0.0, identifier: $0.1.identifier) }
            .disposed(by: disposeBag)
        
//        viewModel.voices
//            .subscribe { [weak self] voices in
//                guard voices.element?.count ?? 0 != 0 else { return }
//
//                let indexPathToSelect = viewModel.getIndexPathForCurrentVoice()
//                self?.selectedLanguageIdentifier = indexPathToSelect
//            }
//            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .orEmpty
//            .debounce(.milliseconds(500), scheduler: MainScheduler.instance) // FIXME: Problem with init loading, why it's affecting first
            .distinctUntilChanged()
            .map { [weak self] in self?.filterDataSource(searchTerm: $0) ?? [] }
            .bind(to: tableView.rx.items(dataSource: getDataSource()))
            .disposed(by: disposeBag)
        
        
//        Observable.combineLatest(viewModel.voices, searchTerm)
//            .map { [weak self] in self?.filterDataSource(for: $0.0, searchTerm: $0.1) ?? $0.0 }
//            .bind(to: tableView.rx.items(dataSource: getDataSource()))
//            .disposed(by: disposeBag)
        
        // TODO: Uncomment when working again
//        rx.methodInvoked(#selector(viewWillLayoutSubviews))
//            .take(1)
//            .withLatestFrom(selectedLanguageIndexPathSubject.compactMap { $0 })
//            .subscribe { [weak self] selectedLanguageIndexPath in
//                guard let indexPath = selectedLanguageIndexPath.element else { return }
//
//                self?.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
//            }
//            .disposed(by: disposeBag)
    }
    
    // TODO: Move to ViewModel
    private func filterDataSource(searchTerm: String) -> [SectionModel<String, AVSpeechSynthesisVoice>] {
        let sectionsWithVoices = viewModel.getSectionsWithVoices()
        
        guard searchTerm.isEmpty == false else { return sectionsWithVoices }
        
        return sectionsWithVoices.compactMap { section in
            let filteredItems = section.items.filter { $0.containsSearchTerm(searchTerm) }
            if filteredItems.isEmpty {
                return nil
            } else {
                return SectionModel(model: section.model, items: filteredItems)
            }
        }
    }
    
    private func getDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, AVSpeechSynthesisVoice>> {
        .init(
            configureCell: { [weak self] _, tableView, indexPath, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Nib.voiceTableViewCell.cellIdentifier) as? VoiceTableViewCell else {
                    return .init()
                }
                
                let numberOfItemsInSection = try? self?.viewModel.voices.value()[indexPath.section].items.count
                let isLastInSection = indexPath.row + 1 == numberOfItemsInSection
                let isSelected = element.identifier == self?.viewModel.selectedLanguageIdentifier
                
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
        let attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [.font: font]) // TODO: Add translation
        
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

    // TODO: Move to ViewModel
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
        guard let sectionTitle = try? viewModel.voices.value()[section].model else { return nil }
        
        let view = HeaderView()
        view.label.text = sectionTitle
        
        return view
    }
    
    // TODO: I don't like this
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 32.0 }
}

// FIXME: Sections have bad titles when searching
