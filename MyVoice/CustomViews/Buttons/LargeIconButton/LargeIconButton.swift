//
//  LargeIconButton.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 17/01/2021.
//

import UIKit
import RxSwift
import AVFoundation

enum SystemVolumeState {
    case noVolume
    case lowVolume
    case mediumVolume
    case highVolume
    
    static func getState(from value: Double?) -> Self {
        let currentVolume = value ?? Double(AVAudioSession.sharedInstance().outputVolume)
        let noVolume = 0.0
        let lowVolume = 0.01...0.25
        let mediumVolume = 0.26...0.75
        
        switch currentVolume {
        case noVolume: return .noVolume
        case lowVolume: return .lowVolume
        case mediumVolume: return .mediumVolume
        default: return .highVolume
        }
    }

    var icon: UIImage? {
        UIImage(
            systemName: iconName,
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )
    }

    private var iconName: String {
        switch self {
        case .noVolume: "speaker.fill"
        case .lowVolume: "speaker.wave.1.fill"
        case .mediumVolume: "speaker.wave.2.fill"
        case .highVolume: "speaker.wave.3.fill"
        }
    }
}

// TODO: Whole button needs to be written from scratch
// Not as XIB, from code - so liquid glass efect will animate properly

enum ActionType {
    case speak(isSpeaking: Bool)
    case display
    case save

    var title: String {
        switch self {
        case .speak(let isSpeaking):
            isSpeaking ? NSLocalizedString("Stop", comment: "Stop") : NSLocalizedString("Speak", comment: "Speak")
        case .display:
            NSLocalizedString("Display", comment: "Display")
        case .save:
            NSLocalizedString("Save", comment: "Save")
        }
    }

    var backgroundColor: UIColor? {
        switch self {
        case .speak(let isSpeaking):
            isSpeaking ? UIColor.redLight : UIColor.orangeLight
        case .display, .save:
            UIColor.orangeLight
        }
    }

    var tintColor: UIColor? {
        switch self {
        case .speak(let isSpeaking):
            isSpeaking ? UIColor.redMain : UIColor.orangeMain
        case .display, .save:
            UIColor.orangeMain
        }
    }

    func getIcon(with volumeState: SystemVolumeState) -> UIImage? {
        switch self {
        case .speak:
            volumeState.icon
        case .display:
            UIImage(systemName: "arrow.up.left.and.arrow.down.right", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        case .save:
            UIImage(systemName: "plus.bubble.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        }
    }
}

final class LargeIconButton: UIButton {
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    private var shadowLayer: CAShapeLayer!

    private lazy var backgroundView: UIVisualEffectView = {
        .init()
    }()

    let isSpeaking = BehaviorSubject<Bool>(value: false)
    let systemVolumeState = BehaviorSubject<SystemVolumeState>(value: .lowVolume)
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
        bindRxValues()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupLayout()
        bindRxValues()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if #available(iOS 26.0, *) {
            return
        } else {
            switch traitCollection.userInterfaceStyle {
            case .light: addShadow(color: .blueDark ?? .black, alpha: 0.25, x: 0, y: 2, blur: 12, spread: -2)
            default: addShadow(color: .blueDark ?? .black, alpha: 0.0, x: 0, y: 2, blur: 12, spread: -2)
            }
        }
    }
    
    private func setupLayout() {
        Bundle.main.loadNibNamed("LargeIconButton", owner: self)
        
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

//        setupBackground()

//        if #available(iOS 26.0, *) {
//            return
//        } else {
            addTarget(self, action: #selector(buttonPressed), for: .touchDown)
            addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
            addTarget(self, action: #selector(buttonReleased), for: .touchUpOutside)
//        }
    }

    private func setupBackground() {
        insertSubview(backgroundView, at: 0)
        backgroundView.frame = bounds
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        if #available(iOS 26.0, *) {
            let glassEffect = UIGlassEffect()
            glassEffect.isInteractive = true
            glassEffect.tintColor = .whiteCustom

            backgroundView.cornerConfiguration = .corners(radius: .init(floatLiteral: System.cornerRadius))

            UIView.animate { backgroundView.effect = glassEffect }
        } else {
            backgroundView.backgroundColor = .whiteCustom ?? .white
        }
    }

    private func addShadow(
        color: UIColor = .black,
        alpha: Float = 0.2,
        x: CGFloat = 0.0,
        y: CGFloat = 2.0,
        blur: CGFloat = 4.0,
        spread: CGFloat = 0.0
    ) {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: System.cornerRadius).cgPath
            shadowLayer.fillColor = UIColor.whiteCustom?.cgColor
            
            shadowLayer.shadowColor = color.cgColor
            shadowLayer.shadowOffset = CGSize(width: x, height: y)
            shadowLayer.shadowOpacity = alpha
            shadowLayer.shadowRadius = blur / 2

            if spread == 0 {
                layer.shadowPath = nil
            } else {
                let dx = -spread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            }
            
            layer.insertSublayer(shadowLayer, at: 0)
        } else {
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: System.cornerRadius).cgPath
            shadowLayer.fillColor = UIColor.whiteCustom?.cgColor
            shadowLayer.shadowOpacity = alpha
        }
    }
    
    func setupLayout(for actionType: ActionType) {
        setupIcon(actionType: actionType)
        setupTitleLabel(actionType: actionType)
        layer.backgroundColor = nil
        contentView.backgroundColor = nil
        contentView.isUserInteractionEnabled = false
    }
    
    private func setupTitleLabel(actionType: ActionType) {
        let attributedText = NSMutableAttributedString(string: actionType.title, attributes: [NSAttributedString.Key.kern: 0.6])
        attributedText.addAttribute(.font, value: Fonts.Poppins.bold(15.0).font, range: NSMakeRange(0, attributedText.length))
        attributedText.addAttribute(.foregroundColor, value: UIColor.blackCustom ?? .black, range: NSMakeRange(0, attributedText.length))
        setTitle(nil, for: .normal)
        mainTitleLabel.text = nil
        mainTitleLabel.attributedText = attributedText
    }
    
    private func setupIcon(actionType: ActionType) {
        iconContainerView.layer.cornerRadius = iconContainerView.frame.width / 2

        iconContainerView.backgroundColor = actionType.backgroundColor
        iconImageView.tintColor = actionType.tintColor
        iconImageView.image = actionType.getIcon(with: SystemVolumeState.getState(from: nil))
    }
    
    // MARK: Methods for Speak button
    
    private func bindRxValues() {
        isSpeaking
            .skip(1)
            .subscribe { [weak self] isSpeaking in
                self?.setupForSpeakButton(isSpeaking: isSpeaking)
            }
            .disposed(by: disposeBag)

        // TODO: Debug what happens when volume is changed while button is in speaking state
        systemVolumeState
            .skip(1)
            .subscribe { [weak self] volumeState in
                guard let state = volumeState.element, let isSpeaking = try? self?.isSpeaking.value(), isSpeaking == false else { return }
                
                self?.iconImageView.image = ActionType.speak(isSpeaking: isSpeaking).getIcon(with: state)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupForSpeakButton(isSpeaking: Bool = false) {
        iconContainerView.backgroundColor = ActionType.speak(isSpeaking: isSpeaking).backgroundColor
        iconImageView.tintColor = ActionType.speak(isSpeaking: isSpeaking).tintColor
        iconImageView.image = ActionType.speak(isSpeaking: isSpeaking).getIcon(with: SystemVolumeState.getState(from: nil))
        setupTitleLabel(actionType: ActionType.speak(isSpeaking: isSpeaking))
    }
    
    // MARK: Handle button touch state
    
    @objc
    private func buttonPressed() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    @objc
    private func buttonReleased() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.transform = CGAffineTransform.identity
        }
    }
}
