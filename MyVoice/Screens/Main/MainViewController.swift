//
//  MainViewController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit
import RxCocoa

class MainViewController: BaseViewController<MainViewModel> {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainTextView: MainTextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var speakButton: LargeIconButton!
    @IBOutlet weak var clearButton: LargeIconButton!
    @IBOutlet weak var saveButton: LargeIconButton!
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var quickAccessTableView: ContentSizedTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "MyVoice"
        self.view.backgroundColor = UIColor(named: "Blue (Light)")
        self.quickAccessTableView.delegate = self
        self.addNavigationBarButtons()
        self.setupLargeButtons()
        self.setupPlaceholderLabel()
        self.setupHeader()
        self.hideKeyboardWhenTappedAround()
        self.listenForActiveStateChange()
    }
        
    override func bindViewModel(viewModel: MainViewModel) {
        super.bindViewModel(viewModel: viewModel)
        
        self.quickAccessTableView.register(UINib(nibName: "QuickPhraseTableViewCell", bundle: nil), forCellReuseIdentifier: "quickPhraseTableViewCell")
        
        quickAccessTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            let cell = self?.quickAccessTableView.cellForRow(at: indexPath) as? QuickPhraseTableViewCell
            cell?.setupIcon(isSpeaking: true)
        }).disposed(by: disposeBag)
        
        quickAccessTableView.rx.modelSelected(QuickPhraseModel.self).subscribe(onNext: { model in
            viewModel.startSpeaking(model.phrase)
        }).disposed(by: disposeBag)
        
        // TODO: Remove subscribing to isSpeaking, store currently active phrase/cell in this view
        viewModel.quickPhraseItems.bind(to: quickAccessTableView.rx.items(cellIdentifier: "quickPhraseTableViewCell", cellType: QuickPhraseTableViewCell.self)) { [weak self] (row, item, cell) in
            do {
                let numberOfItems = try viewModel.quickPhraseItems.value().count
                if numberOfItems == 1 {
                    cell.setupCell(phrase: item.phrase, type: .onlyCell)
                } else if row == 0 {
                    cell.setupCell(phrase: item.phrase, type: .firstCell)
                } else if row == numberOfItems - 1 {
                    cell.setupCell(phrase: item.phrase, type: .lastCell)
                } else {
                    cell.setupCell(phrase: item.phrase, type: .defaultCell)
                }
                cell.isSpeaking.subscribe(viewModel.isSpeaking).disposed(by: cell.disposeBag)
            } catch {
                self?.logError(with: error)
            }
        }.disposed(by: disposeBag)
        
        viewModel.isSpeaking.skip(1).subscribe { [weak self] isSpeaking in
            self?.speakButton.isSpeaking.onNext(isSpeaking)
        }.disposed(by: disposeBag)
        
        self.mainTextView.rx.text.subscribe(onNext: { [weak self] text in
            self?.placeholderLabel.isHidden = text?.isEmpty == false
        }).disposed(by: disposeBag)
    }
    
    // MARK: Setting up
    
    private func setupLargeButtons() {
        self.speakButton.setupLayout(forTitle: "Speak", actionType: .speak)
        self.clearButton.setupLayout(forTitle: "Clear", actionType: .clear)
        self.saveButton.setupLayout(forTitle: "Save", actionType: .save)
    }
    
    private func setupPlaceholderLabel() {
        self.placeholderLabel.text = "What do you want to say?"
        self.placeholderLabel.textColor = UIColor(named: "Blue (Dark)")
        self.placeholderLabel.font = UIFont(name: "Poppins-Bold", size: 20)
    }
    
    private func setupHeader() {
        self.headerTitleLabel.text = "Quick access"
        self.editButton.setTitle("Edit", for: .normal)
    }
    
    private func listenForActiveStateChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc
    func appMovedToBackground() {
        self.viewModel.stopSpeaking()
    }
    
    // MARK: Navigation Bar items methods
    
    private func addNavigationBarButtons() {
        let font = UIFont(name: "Poppins-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let color = UIColor(named: "Orange (Main)") ?? .orange
        
        let leftItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(helpDidTouch))
        leftItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                         NSAttributedString.Key.foregroundColor: color], for: .normal)
        leftItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .selected)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsDidTouch))
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .normal)
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .selected)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc
    private func helpDidTouch() {
        
    }
    
    @objc
    private func settingsDidTouch() {
        
    }
    
    @IBAction
    func speakButtonDidTouch(_ sender: Any) {
        do {
            if try viewModel.isSpeaking.value() == true {
                self.viewModel.stopSpeaking()
            } else {
                guard let text = self.mainTextView.text, text.isEmpty == false else { return }
                self.viewModel.startSpeaking(text)
            }
        } catch {
            logError(with: error)
        }
    }
    
    @IBAction
    func clearButtonDidTouch(_ sender: Any) {
        self.mainTextView.text = nil
    }
    
    @IBAction
    func saveButtonDidTouch(_ sender: Any) {
        logSuccess(with: "Save")
    }
    
    @IBAction
    func editButtonDidTouch(_ sender: Any) {
        logSuccess(with: "Edit")
    }
}

extension MainViewController: UITableViewDelegate {
    
    
    // FIXME: Touch not working properly
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logSuccess(with: "woohoo")
        guard let items = try? self.viewModel.quickPhraseItems.value() else { return }
        let phrase = items[indexPath.row].phrase
        let cell = self.quickAccessTableView.cellForRow(at: indexPath) as? QuickPhraseTableViewCell
        cell?.setupIcon(isSpeaking: true)
        self.viewModel.startSpeaking(phrase)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        <#code#>
//    }
}
