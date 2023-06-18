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
    
    private let selectedLanguageIndexPathSubject = BehaviorSubject<IndexPath?>(value: nil)
    private var selectedLanguageIndexPath: IndexPath? {
        get { try? selectedLanguageIndexPathSubject.value() }
        set { selectedLanguageIndexPathSubject.onNext(newValue) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Select voice", comment: "Select voice")
        view.backgroundColor = .background
        tableView.backgroundColor = .clear
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
        
        viewModel.voices
            .bind(to: tableView.rx.items(dataSource: getDataSource()))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { [weak self] in self?.didSelectRowAt($0) }
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(viewWillLayoutSubviews))
            .take(1)
            .withLatestFrom(selectedLanguageIndexPathSubject.compactMap { $0 })
            .subscribe { [weak self] selectedLanguageIndexPath in
                guard let indexPath = selectedLanguageIndexPath.element else { return }
                
                self?.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
            .disposed(by: disposeBag)
        
        viewModel.voices
            .subscribe { [weak self] voices in
                guard voices.element?.count ?? 0 != 0 else { return }
                
                let indexPathToSelect = viewModel.getIndexPathForCurrentVoice()
                self?.selectedLanguageIndexPath = indexPathToSelect
            }
            .disposed(by: disposeBag)
    }
    
    private func getDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, AVSpeechSynthesisVoice>> {
        .init(
            configureCell: { [weak self] _, tableView, indexPath, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Nib.voiceTableViewCell.cellIdentifier) as? VoiceTableViewCell else {
                    return .init()
                }
                
                let numberOfItemsInSection = try? self?.viewModel.voices.value()[indexPath.section].items.count
                let isLastInSection = indexPath.row + 1 == numberOfItemsInSection
                let isSelected = indexPath == self?.selectedLanguageIndexPath
                
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
    
    // MARK: Navigation Bar items methods
    
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

    private func didSelectRowAt(_ indexPath: IndexPath) {        
        if let previousSelectedIndexPath = selectedLanguageIndexPath, previousSelectedIndexPath != indexPath {
            let previousSelectedCell = tableView.cellForRow(at: previousSelectedIndexPath) as? VoiceTableViewCell
            previousSelectedCell?.checkmarkImageView.isHidden = true
        }
        
        selectedLanguageIndexPath = indexPath
        
        let cell = tableView.cellForRow(at: indexPath) as? VoiceTableViewCell
        cell?.checkmarkImageView.isHidden = false
        
        viewModel.selectVoiceForIndexPath(indexPath)
        
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
}
