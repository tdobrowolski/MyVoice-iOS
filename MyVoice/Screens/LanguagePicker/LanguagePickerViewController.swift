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

final class LanguagePickerViewController: BaseViewController<LanguagePickerViewModel> {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedLanguageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Select voice", comment: "Select voice")
        view.backgroundColor = UIColor(named: "Background")
        addNavigationBarButton()
        tableView.register(UINib(nibName: "VoiceCellTableViewCell", bundle: nil), forCellReuseIdentifier: "voiceCell")
    }
    
    override func bindViewModel(_ viewModel: LanguagePickerViewModel) {
        super.bindViewModel(viewModel)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.availableVoices.bind(to: tableView.rx.items(cellIdentifier: "voiceCell", cellType: VoiceCellTableViewCell.self)) { [weak self] (row, item, cell) in
            let fullLanguage = NSLocale(localeIdentifier: NSLocale.current.identifier).displayName(forKey: NSLocale.Key.identifier, value: item.language)
            cell.setupCell(languageName: fullLanguage ?? NSLocalizedString("Unknown", comment: "Unknown"), voiceName: item.name, voiceQuality: item.quality, voiceGender: item.gender, isSelected: row == self?.selectedLanguageIndex)
        }.disposed(by: disposeBag)
        
        viewModel.availableVoices.subscribe { [weak self] languages in
            guard languages.element?.count ?? 0 != 0 else { return }

            let indexToSelect = viewModel.getIndexForCurrentVoice()
            self?.selectedLanguageIndex = indexToSelect
        }.disposed(by: disposeBag)
    }
    
    // MARK: Navigation Bar items methods
    
    private func addNavigationBarButton() {
        let font = UIFont(name: "Poppins-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let color = UIColor(named: "Orange (Main)") ?? .orange
        
        let rightItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: "Done"), style: .plain, target: self, action: #selector(doneDidTouch))
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .normal)
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .selected)
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc
    private func doneDidTouch() { dismiss(animated: true, completion: nil) }
}

extension LanguagePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let previousSelectedIndex = selectedLanguageIndex, previousSelectedIndex != indexPath.row {
            let previousSelectedCell = tableView.cellForRow(at: IndexPath(row: previousSelectedIndex, section: 0)) as? VoiceCellTableViewCell
            previousSelectedCell?.checkmarkImageView.isHidden = true
        }

        selectedLanguageIndex = indexPath.row

        let cell = tableView.cellForRow(at: indexPath) as? VoiceCellTableViewCell
        cell?.checkmarkImageView.isHidden = false

        viewModel.selectVoiceForIndexPath(indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
