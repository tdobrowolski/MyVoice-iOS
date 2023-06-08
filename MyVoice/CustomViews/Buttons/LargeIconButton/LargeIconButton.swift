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
//        let highVolume = 0.76...1.0

        if currentVolume == noVolume {
            return .noVolume
        } else if lowVolume.contains(currentVolume) {
            return .lowVolume
        } else if mediumVolume.contains(currentVolume) {
            return .mediumVolume
        } else {
            return .highVolume
        }
    }
}

final class LargeIconButton: UIButton {
    enum ActionType {
        case speak
        case clear
        case save
    }
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    private var shadowLayer: CAShapeLayer!
    
    let isSpeaking = BehaviorSubject<Bool>(value: false)
    let systemVolumeState = BehaviorSubject<SystemVolumeState>(value: .lowVolume)
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        customInit()
    }
    
    private func customInit() {
        Bundle.main.loadNibNamed("LargeIconButton", owner: self, options: nil)
        addSubview(self.contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpInside)
        addTarget(self, action: #selector(buttonReleased), for: .touchUpOutside)
        bindRxValues()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch traitCollection.userInterfaceStyle {
        case .light:
            addShadow(color: .blueDark ?? .black, alpha: 0.25, x: 0, y: 2, blur: 12, spread: -2)

        default:
            addShadow(color: .blueDark ?? .black, alpha: 0.0, x: 0, y: 2, blur: 12, spread: -2)
        }
    }
    
    private func addShadow(color: UIColor = .black, alpha: Float = 0.2, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
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
            shadowLayer.fillColor = UIColor.whiteCustom?.cgColor
            shadowLayer.shadowOpacity = alpha
        }
    }
    
    func setupLayout(forTitle title: String, actionType: ActionType) {
        setupIcon(actionType: actionType)
        setupTitleLabel(title: title)
        layer.backgroundColor = nil
        contentView.backgroundColor = nil
        contentView.isUserInteractionEnabled = false
    }
    
    private func setupTitleLabel(title: String) {
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.kern: 0.6])
        attributedText.addAttribute(.font, value: Fonts.Poppins.bold(15.0).font, range: NSMakeRange(0, attributedText.length))
        attributedText.addAttribute(.foregroundColor, value: UIColor.blackCustom ?? .black, range: NSMakeRange(0, attributedText.length))
        setTitle(nil, for: .normal)
        mainTitleLabel.text = nil
        mainTitleLabel.attributedText = attributedText
    }
    
    private func setupIcon(actionType: ActionType) {
        iconContainerView.layer.cornerRadius = self.iconContainerView.frame.width / 2

        switch actionType {
        case .speak:
            iconContainerView.backgroundColor = .orangeLight ?? .white
            iconImageView.tintColor = .orangeMain ?? .orange
            iconImageView.image = self.getSystemVolumeIcon()

        case .clear:
            iconContainerView.backgroundColor = .redLight ?? .white
            iconImageView.tintColor = .redMain ?? .red
            iconImageView.image = UIImage(systemName: "pencil.slash", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))

        case .save:
            iconContainerView.backgroundColor = .orangeLight ?? .white
            iconImageView.tintColor = .orangeMain ?? .orange
            iconImageView.image = UIImage(systemName: "plus.bubble.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        }
    }
    
    // MARK: Methods for Speak button
    
    private func bindRxValues() {
        isSpeaking.skip(1).subscribe { [weak self] isSpeaking in
            self?.setupForSpeakButton(isSpeaking: isSpeaking)
        }.disposed(by: disposeBag)
        
        systemVolumeState.skip(1).subscribe { [weak self] volumeState in
            guard let state = volumeState.element, let isSpeaking = try? self?.isSpeaking.value(), isSpeaking == false else { return }
            
            self?.iconImageView.image = self?.getSystemVolumeIcon(for: state)
        }.disposed(by: disposeBag)
    }
    
    private func getSystemVolumeIcon(for volumeState: SystemVolumeState? = nil) -> UIImage? {
        switch volumeState ?? SystemVolumeState.getState(from: nil) {
        case .noVolume:
            return UIImage(systemName: "speaker.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))

        case .lowVolume:
            if #available(iOS 14, *) {
                return UIImage(systemName: "speaker.wave.1.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            } else {
                return UIImage(systemName: "speaker.1.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            }

        case .mediumVolume:
            if #available(iOS 14, *) {
                return UIImage(systemName: "speaker.wave.2.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            } else {
                return UIImage(systemName: "speaker.2.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            }

        case .highVolume:
            if #available(iOS 14, *) {
                return UIImage(systemName: "speaker.wave.3.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            } else {
                return UIImage(systemName: "speaker.3.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            }
        }
    }
    
    private func setupForSpeakButton(isSpeaking: Bool = false) {
        if isSpeaking {
            iconContainerView.backgroundColor = .redLight ?? .white
            iconImageView.tintColor = .redMain ?? .red
            iconImageView.image = UIImage(systemName: "stop.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            setupTitleLabel(title: NSLocalizedString("Stop", comment: "Stop"))
        } else {
            iconContainerView.backgroundColor = .orangeLight ?? .white
            iconImageView.tintColor = .orangeMain ?? .orange
            iconImageView.image = self.getSystemVolumeIcon()
            setupTitleLabel(title: NSLocalizedString("Speak", comment: "Speak"))
        }
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
