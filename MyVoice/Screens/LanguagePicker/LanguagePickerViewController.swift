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

        self.title = "Select voice"
        self.view.backgroundColor = UIColor(named: "Blue (Light)")
        self.addNavigationBarButton()
        self.tableView.register(UINib(nibName: "VoiceCellTableViewCell", bundle: nil), forCellReuseIdentifier: "voiceCell")
    }
    
    override func bindViewModel(viewModel: LanguagePickerViewModel) {
        super.bindViewModel(viewModel: viewModel)
        
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.availableVoices.bind(to: tableView.rx.items(cellIdentifier: "voiceCell", cellType: VoiceCellTableViewCell.self)) { [weak self] (row, item, cell) in
            let fullLanguage = NSLocale(localeIdentifier: NSLocale.current.identifier).displayName(forKey: NSLocale.Key.identifier, value: item.language)
            cell.setupCell(languageName: fullLanguage ?? "Unknown", voiceName: item.name, voiceQuality: item.quality, voiceGender: item.gender, isSelected: row == self?.selectedLanguageIndex)
        }.disposed(by: disposeBag)
        
        viewModel.availableVoices.subscribe { [weak self] languages in
            if languages.element?.count ?? 0 == 0 { return }
            let indexToSelect = viewModel.getIndexForCurrentVoice()
            self?.selectedLanguageIndex = indexToSelect
        }.disposed(by: disposeBag)
    }
    
    // MARK: Navigation Bar items methods
    
    private func addNavigationBarButton() {
        let font = UIFont(name: "Poppins-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17)
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
        self.dismiss(animated: true, completion: nil)
    }
}

extension LanguagePickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let previousSelectedIndex = self.selectedLanguageIndex, previousSelectedIndex != indexPath.row {
            let previousSelectedCell = self.tableView.cellForRow(at: IndexPath(row: previousSelectedIndex, section: 0)) as? VoiceCellTableViewCell
            previousSelectedCell?.checkmarkImageView.isHidden = true
        }
        self.selectedLanguageIndex = indexPath.row
        let cell = self.tableView.cellForRow(at: indexPath) as? VoiceCellTableViewCell
        cell?.checkmarkImageView.isHidden = false
        self.viewModel.selectVoiceForIndexPath(indexPath)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
