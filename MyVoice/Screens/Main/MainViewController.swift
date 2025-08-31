//
//  MainViewController.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit
import RxCocoa
import RxDataSources
import SwiftUI

final class MainViewController: BaseViewController<MainViewModel> {
    @IBOutlet weak var scrollView: CustomScrollView!
    
    @IBOutlet weak var mainTextView: MainTextView!
    @IBOutlet weak var placeholderTextView: UITextView!
    @IBOutlet weak var backgroundShadowView: BackgroundShadowView!
    
    @IBOutlet weak var speakContainer: UIView!
    @IBOutlet weak var displayContainer: UIView!
    @IBOutlet weak var saveContainer: UIView!

    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var quickAccessTableView: ContentSizedTableView!
    
    @IBOutlet weak var quickAccessPlaceholderView: UIView!
    @IBOutlet weak var quickAccessPlaceholderImageView: UIImageView!
    @IBOutlet weak var quickAccessPlaceholderMainLabel: UILabel!
    @IBOutlet weak var quickAccessPlaceholderSecondaryLabel: UILabel!

    private var speakHostingController: UIHostingController<ActionButton>?
    private var displayHostingController: UIHostingController<ActionButton>?
    private var saveHostingController: UIHostingController<ActionButton>?

    private var speakButtonViewState = SpeakButtonViewState()

    private var dataSource: RxTableViewSectionedAnimatedDataSource<QuickPhraseSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("MyVoice", comment: "MyVoice")
        view.backgroundColor = .background
        
        quickAccessTableView.delegate = self
        quickAccessTableView.layer.cornerRadius = 16
        quickAccessTableView.isScrollEnabled = false
        
        addNavigationBarButtons()
        setupSpeakButton()
        setupDisplayButton()
        setupSaveButton()
        setupPlaceholderLabel()
        setupQuickAccessPlaceholder()
        setupHeader()
        hideKeyboardWhenTappedAround()
        listenForActiveStateChange()
    }

    override func bindViewModel(_ viewModel: MainViewModel) {
        super.bindViewModel(viewModel)
        
        quickAccessTableView.register(
            UINib(nibName: Nib.quickPhraseTableViewCell.name, bundle: nil),
            forCellReuseIdentifier: Nib.quickPhraseTableViewCell.cellIdentifier
        )
        
        dataSource = getDataSourceForQuickPhrase()
        
        viewModel.sections
            .bind(to: quickAccessTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        quickAccessTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.sections
            .subscribe { [weak self] sections in
                let quickPhraseItems = sections[0].items
                if quickPhraseItems.isEmpty {
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear) { [weak self] in
                        self?.quickAccessPlaceholderView.isHidden = false
                        self?.quickAccessPlaceholderView.alpha = 1
                        self?.quickAccessTableView.alpha = 0
                    } completion: { [weak self] _ in
                        self?.quickAccessTableView.isHidden = true
                    }
                } else {
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear) { [weak self] in
                        self?.quickAccessTableView.isHidden = false
                        self?.quickAccessTableView.alpha = 1
                        self?.quickAccessPlaceholderView.alpha = 0
                    } completion: { [weak self] _ in
                        self?.quickAccessPlaceholderView.isHidden = true
                    }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isSpeaking
            .skip(1)
            .subscribe { [weak self] isSpeaking in
                self?.speakButtonViewState.isSpeaking = isSpeaking
            }
            .disposed(by: disposeBag)
        
        mainTextView.rx.text
            .subscribe { [weak self] text in
                self?.placeholderTextView.isHidden = text?.isEmpty == false
            }
            .disposed(by: disposeBag)
        
        viewModel.systemVolumeState
            .skip(1)
            .subscribe { [weak self] volumeState in
                self?.speakButtonViewState.systemVolumeState = volumeState
            }
            .disposed(by: disposeBag)
    }

    // FIXME: Fix memory leak, cells are not deinitialised
    func getDataSourceForQuickPhrase() -> RxTableViewSectionedAnimatedDataSource<QuickPhraseSection> {
        RxTableViewSectionedAnimatedDataSource<QuickPhraseSection> (
            configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
                guard let self else { return UITableViewCell() }
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: Nib.quickPhraseTableViewCell.cellIdentifier) as? QuickPhraseTableViewCell {
                    let itemsEndIndex = (try? self.viewModel.sections.value().first?.items.endIndex) ?? 1
                    
                    cell.setupCell(phrase: item.phrase, isFirstCell: indexPath.row == 0, isLastCell: indexPath.row == itemsEndIndex - 1)
                    self.viewModel.isSpeaking.subscribe(cell.isSpeaking).disposed(by: cell.disposeBag)
                    cell.tapHandlerButton.rx.tap
                        .subscribe { [weak self] _ in
                            let isSpeaking = try? self?.viewModel.isSpeaking.value()
                            guard let text = cell.phraseLabel?.text, text.isEmpty == false, isSpeaking == false else { return }
                            
                            self?.viewModel.startSpeaking(text)
                            cell.setupIcon(isSpeaking: true)
                        }
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                } else {
                    return UITableViewCell()
                }
            },
            canEditRowAtIndexPath: { _, _ in true }
        )
    }
    
    // MARK: Setting up
    
    private func setupPlaceholderLabel() {
        placeholderTextView.text = NSLocalizedString("What do you want to say?", comment: "What do you want to say?")
        placeholderTextView.textContainerInset = .init(top: 13, left: 14, bottom: 14, right: 13)
        placeholderTextView.textColor = .blueDark
        placeholderTextView.font = Fonts.Poppins.bold(20.0).font
    }
    
    private func setupHeader() {
        headerTitleLabel.text = NSLocalizedString("Quick access", comment: "Quick access")
        headerTitleLabel.font = Fonts.Poppins.bold(20.0).font
        editButton.setTitle(NSLocalizedString("Edit", comment: "Edit"), for: .normal)
    }

    private func setupSpeakButton() {
        let swiftUIView = ActionButton(
            type: .speak,
            onTap: speakButtonDidTouch,
            state: speakButtonViewState
        )

        speakHostingController = UIHostingController(rootView: swiftUIView)

        guard let speakHostingController else { return }

        addChild(speakHostingController)
        speakContainer.addSubview(speakHostingController.view)
        speakHostingController.view.backgroundColor = nil
        speakHostingController.didMove(toParent: self)

        speakHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            speakHostingController.view.topAnchor.constraint(equalTo: speakContainer.topAnchor),
            speakHostingController.view.leadingAnchor.constraint(equalTo: speakContainer.leadingAnchor),
            speakHostingController.view.trailingAnchor.constraint(equalTo: speakContainer.trailingAnchor),
            speakHostingController.view.bottomAnchor.constraint(equalTo: speakContainer.bottomAnchor)
        ])
    }

    private func setupDisplayButton() {
        let swiftUIView = ActionButton(
            type: .display,
            onTap: displayButtonDidTouch,
            state: speakButtonViewState
        )

        displayHostingController = UIHostingController(rootView: swiftUIView)

        guard let displayHostingController else { return }

        addChild(displayHostingController)
        displayContainer.addSubview(displayHostingController.view)
        displayHostingController.view.backgroundColor = nil
        displayHostingController.didMove(toParent: self)

        displayHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayHostingController.view.topAnchor.constraint(equalTo: displayContainer.topAnchor),
            displayHostingController.view.leadingAnchor.constraint(equalTo: displayContainer.leadingAnchor),
            displayHostingController.view.trailingAnchor.constraint(equalTo: displayContainer.trailingAnchor),
            displayHostingController.view.bottomAnchor.constraint(equalTo: displayContainer.bottomAnchor)
        ])
    }

    private func setupSaveButton() {
        let swiftUIView = ActionButton(
            type: .save,
            onTap: saveButtonDidTouch,
            state: speakButtonViewState
        )

        saveHostingController = UIHostingController(rootView: swiftUIView)

        guard let saveHostingController else { return }

        addChild(saveHostingController)
        saveContainer.addSubview(saveHostingController.view)
        saveHostingController.view.backgroundColor = nil
        saveHostingController.didMove(toParent: self)

        saveHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveHostingController.view.topAnchor.constraint(equalTo: saveContainer.topAnchor),
            saveHostingController.view.leadingAnchor.constraint(equalTo: saveContainer.leadingAnchor),
            saveHostingController.view.trailingAnchor.constraint(equalTo: saveContainer.trailingAnchor),
            saveHostingController.view.bottomAnchor.constraint(equalTo: saveContainer.bottomAnchor)
        ])
    }

    private func setupQuickAccessPlaceholder() {
        quickAccessPlaceholderMainLabel.text = NSLocalizedString("You have no phrases yet!", comment: "You have no hrases yet!")
        quickAccessPlaceholderMainLabel.font = Fonts.Poppins.bold(18.0).font
        quickAccessPlaceholderSecondaryLabel.text = NSLocalizedString("To add your first phrase tap on \n„Save” button.", comment: "Placeholder text with line break")
        quickAccessPlaceholderSecondaryLabel.font = Fonts.Poppins.semibold(14.0).font
    }
    
    private func listenForActiveStateChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc
    func appMovedToBackground() { viewModel.stopSpeaking() }
    
    // MARK: Navigation Bar items methods
    
    private func addNavigationBarButtons() {
        let font = Fonts.Poppins.medium(17.0).font
        let color = UIColor.orangeMain ?? .orange
        
        let leftItem = UIBarButtonItem(title: NSLocalizedString("Help", comment: "Help"), style: .plain, target: self, action: #selector(helpDidTouch))
        leftItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                         NSAttributedString.Key.foregroundColor: color], for: .normal)
        leftItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                         NSAttributedString.Key.foregroundColor: color], for: .selected)
        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: "Settings"), style: .plain, target: self, action: #selector(settingsDidTouch))
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .normal)
        rightItem.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                          NSAttributedString.Key.foregroundColor: color], for: .selected)
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc
    private func helpDidTouch() {
        viewModel.stopSpeaking()
        let helpViewModel = HelpViewModel(
            supportsPersonalVoice: viewModel.personalVoiceService.isSupported,
            onDone: { [weak self] in self?.dismiss(animated: true) }
        )
        let helpViewController = HelpView(
            viewModel: helpViewModel
        ).asViewController
        let helpNavigationController = DefaultNavigationController(rootViewController: helpViewController)
        
        present(helpNavigationController, animated: true, completion: nil)
    }
    
    @objc
    private func settingsDidTouch() {
        viewModel.stopSpeaking()
        let settingsViewModel = SettingsViewModel(personalVoiceService: viewModel.personalVoiceService)
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel, nibName: Nib.settingsViewController.name)
        let settingsNavigationController = DefaultNavigationController(rootViewController: settingsViewController)
        
        present(settingsNavigationController, animated: true, completion: nil)
    }
    
    func speakButtonDidTouch() {
        do {
            if try viewModel.isSpeaking.value() == true {
                viewModel.stopSpeaking()
            } else {
                guard let text = mainTextView.text, text.isEmpty == false else {
                    placeholderTextView.flashWithColor(.orangeMain ?? .orange)
                    viewModel.warnUserWithFeedback()
                    
                    return
                }
                
                viewModel.startSpeaking(text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        } catch {
            logError(with: error)
        }
    }

    // TODO: Implement proper functionality
    func displayButtonDidTouch() {
        viewModel.impactUserWithFeedback()

        let displayViewController = DisplayViewController(text: "Large text to display")
        displayViewController.modalPresentationStyle = .fullScreen
        displayViewController.modalTransitionStyle = .crossDissolve

        present(displayViewController, animated: true, completion: nil)
    }
    
    func saveButtonDidTouch() {
        guard let phrase = mainTextView.text, phrase.isEmpty == false else {
            viewModel.warnUserWithFeedback()
            placeholderTextView.flashWithColor(.orangeMain ?? .orange)
            
            return
        }
        
        if let currentFirstCell = self.quickAccessTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? QuickPhraseTableViewCell {
            currentFirstCell.setTipVisibility(isHidden: true)
        }
        
        viewModel.impactUserWithFeedback()
        viewModel.addQuickPhraseItem(phrase: phrase.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    @IBAction
    func editButtonDidTouch(_ sender: Any) { logSuccess(with: "Edit") }
}

extension MainViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: NSLocalizedString("Remove", comment: "Remove")) { [weak self] (action, view, completion) in
            if indexPath.row == 0, let nextFirstCell = self?.quickAccessTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? QuickPhraseTableViewCell {
                completion(true)
                nextFirstCell.setTipVisibility(isHidden: false)
            }
            self?.viewModel.removeQuickPhraseItem(at: indexPath.row)
        }
        delete.backgroundColor = .redMain
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
