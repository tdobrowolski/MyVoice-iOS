//
//  MainViewController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit
import RxCocoa
import RxDataSources

class MainViewController: BaseViewController<MainViewModel> {
    
    // TODO: Fix dark mode for LaunchScreen
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainTextView: MainTextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var speakButton: LargeIconButton!
    @IBOutlet weak var clearButton: LargeIconButton!
    @IBOutlet weak var saveButton: LargeIconButton!
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var quickAccessTableView: ContentSizedTableView!
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<QuickPhraseSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "MyVoice"
        self.view.backgroundColor = UIColor(named: "Background")
        self.quickAccessTableView.delegate = self
        self.quickAccessTableView.layer.cornerRadius = 16
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
        
        self.dataSource = self.getDataSourceForQuickPhrase()
        
        viewModel.sections.bind(to: quickAccessTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        quickAccessTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.sections.subscribe(onNext: { [weak self] sections in
            let quickPhraseItems = sections[0].items
            if quickPhraseItems.isEmpty {
                // TODO: Show placeholder
            } else {
                // TODO: Hide placeholder
            }
        }).disposed(by: disposeBag)

        viewModel.isSpeaking.skip(1).subscribe(onNext: { [weak self] isSpeaking in
            self?.speakButton.isSpeaking.onNext(isSpeaking)
        }).disposed(by: disposeBag)
        
        self.mainTextView.rx.text.subscribe(onNext: { [weak self] text in
            self?.placeholderLabel.isHidden = text?.isEmpty == false
        }).disposed(by: disposeBag)
    }
    
    
    // FIXME: Check why some phrases are said two times
    // FIXME: Fix memory leak, cells are not deinitialised
    func getDataSourceForQuickPhrase() -> RxTableViewSectionedAnimatedDataSource<QuickPhraseSection> {
        return RxTableViewSectionedAnimatedDataSource<QuickPhraseSection> (
            configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
                guard let self = self else { return UITableViewCell() }
                if let cell = tableView.dequeueReusableCell(withIdentifier: "quickPhraseTableViewCell") as? QuickPhraseTableViewCell {
                    cell.setupCell(phrase: item.phrase, isFirstCell: indexPath.row == 0)
                    self.viewModel.isSpeaking.subscribe(cell.isSpeaking).disposed(by: cell.disposeBag)
                    cell.tapHandlerButton.rx.tap.subscribe { [weak self] _ in
                        guard let text = cell.phraseLabel?.text, text.isEmpty == false else { return }
                        self?.viewModel.startSpeaking(text)
                        cell.setupIcon(isSpeaking: true)
                    }.disposed(by: cell.disposeBag)
                    return cell
                } else {
                    return UITableViewCell()
                }
            },
            canEditRowAtIndexPath: { _, _ in
                return true
            }
        )
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
        self.viewModel.stopSpeaking()
        let settingsViewModel = SettingsViewModel()
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel, nibName: "SettingsViewController")
        let settingsNavigationController = DefaultNavigationController(rootViewController: settingsViewController)
        self.present(settingsNavigationController, animated: true, completion: nil)
    }
    
    @IBAction
    func speakButtonDidTouch(_ sender: Any) {
        do {
            if try viewModel.isSpeaking.value() == true {
                self.viewModel.stopSpeaking()
            } else {
                guard let text = self.mainTextView.text, text.isEmpty == false else {
                    self.placeholderLabel.flashWithColor(UIColor(named: "Orange (Main)") ?? .orange)
                    return
                }
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
        guard let phrase = mainTextView.text, phrase.isEmpty == false else {
            self.placeholderLabel.flashWithColor(UIColor(named: "Orange (Main)") ?? .orange)
            return
        }
        if let currentFirstCell = self.quickAccessTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? QuickPhraseTableViewCell {
            currentFirstCell.setTipVisibility(isHidden: true)
        }
        self.viewModel.addQuickPhraseItem(phrase: phrase)
    }
    
    @IBAction
    func editButtonDidTouch(_ sender: Any) {
        logSuccess(with: "Edit")
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Remove") { [weak self] (action, view, completion) in
            if indexPath.row == 0, let nextFirstCell = self?.quickAccessTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? QuickPhraseTableViewCell {
                completion(true)
                nextFirstCell.setTipVisibility(isHidden: false)
            }
            self?.viewModel.removeQuickPhraseItem(at: indexPath.row)
        }
        delete.backgroundColor = UIColor(named: "Red (Main)")
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
