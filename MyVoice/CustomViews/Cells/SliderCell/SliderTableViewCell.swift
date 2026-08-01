//
//  SliderTableViewCell.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 31/01/2021.
//

import UIKit
import RxSwift

final class SliderTableViewCell: UITableViewCell {
    @IBOutlet weak var defaultSlider: UISlider!
    @IBOutlet weak private var centerIndicator: UIView!
    
    lazy var disposeBag = DisposeBag()

    let sliderValueChanged = PublishSubject<Float>()

    func setupSlider(for dataType: SliderDataType) {
        defaultSlider.tintColor = .orangeMain
        defaultSlider.minimumTrackTintColor = .orangeMain
        defaultSlider.maximumTrackTintColor = .blueLight
        centerIndicator.backgroundColor = .blueLight
        defaultSlider.isContinuous = false
        selectionStyle = .none

        switch dataType {
        case .speechRate(let currentValue):
            defaultSlider.minimumValue = SliderDataType.minSpeechRateValue
            defaultSlider.minimumValueImage = UIImage(systemName: "tortoise.fill",
                                               withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            defaultSlider.maximumValue = SliderDataType.maxSpeechRateValue
            defaultSlider.maximumValueImage = UIImage(systemName: "hare.fill",
                                               withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            defaultSlider.setValue(currentValue, animated: false)

        case .speechPitch(let currentValue):
            defaultSlider.minimumValue = SliderDataType.minSpeechPitchValue
            defaultSlider.minimumValueImage = UIImage(systemName: "minus.circle.fill",
                                                      withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large))
            defaultSlider.maximumValue = SliderDataType.maxSpeechPitchValue
            defaultSlider.maximumValueImage = UIImage(systemName: "plus.circle.fill",
                                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large))
            defaultSlider.value = currentValue
        }

        // Fixes problem with valueChanged. It was not called before, when user reached min or max on the slider.
        defaultSlider.addTarget(self, action: #selector(didEndSliderInteraction), for: [.touchUpInside, .touchUpOutside])
    }

    @objc
    func didEndSliderInteraction() {
        sliderValueChanged.onNext(defaultSlider.value)
    }

    func adjustSlider(for value: Float) { defaultSlider.value = value }
    
    override func prepareForReuse() { disposeBag = DisposeBag() }
}
