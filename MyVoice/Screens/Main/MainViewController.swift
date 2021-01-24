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
    
    var currentSpeakingCellRow: Int?
    
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
        
        // TODO: Remove subscribing to isSpeaking, store currently active phrase/cell in this view
        viewModel.quickPhraseItems.bind(to: quickAccessTableView.rx.items(cellIdentifier: "quickPhraseTableViewCell", cellType: QuickPhraseTableViewCell.self)) { [weak self] (row, item, cell) in
            guard let self = self, let numberOfItems = try? viewModel.quickPhraseItems.value().count else { return }
            if numberOfItems == 1 {
                cell.setupCell(phrase: item.phrase, type: .onlyCell)
            } else if row == 0 {
                cell.setupCell(phrase: item.phrase, type: .firstCell)
            } else if row == numberOfItems - 1 {
                cell.setupCell(phrase: item.phrase, type: .lastCell)
            } else {
                cell.setupCell(phrase: item.phrase, type: .defaultCell)
            }
            
            cell.tapHandlerButton.tag = row
            cell.tapHandlerButton.addTarget(self, action: #selector(self.quickPhraseCellSelected(sender:)), for: .touchUpInside)
        }.disposed(by: disposeBag)
        
        viewModel.isSpeaking.skip(1).subscribe(onNext: { [weak self] isSpeaking in
            self?.speakButton.isSpeaking.onNext(isSpeaking)
            if let speakingCellRow = self?.currentSpeakingCellRow, isSpeaking == false {
                let cell = self?.quickAccessTableView.cellForRow(at: IndexPath(row: speakingCellRow, section: 0)) as? QuickPhraseTableViewCell
                cell?.setupIcon(isSpeaking: false)
                self?.currentSpeakingCellRow = nil
            }
        }).disposed(by: disposeBag)
        
        self.mainTextView.rx.text.subscribe(onNext: { [weak self] text in
            self?.placeholderLabel.isHidden = text?.isEmpty == false
        }).disposed(by: disposeBag)
    }
    
    // MARK: Handling speaking action for cell
    
    @objc
    private func quickPhraseCellSelected(sender: UIButton) {
        self.speakPhraseFromCell(with: sender.tag)
    }
    
    private func speakPhraseFromCell(with row: Int) {
        guard let items = try? viewModel.quickPhraseItems.value(), items.indices.contains(row) else { return }
        let phrase = items[row].phrase
        let cell = self.quickAccessTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? QuickPhraseTableViewCell
        cell?.setupIcon(isSpeaking: true)
        self.currentSpeakingCellRow = row
        self.viewModel.startSpeaking(phrase)
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

extension MainViewController: UITableViewDelegate { }
