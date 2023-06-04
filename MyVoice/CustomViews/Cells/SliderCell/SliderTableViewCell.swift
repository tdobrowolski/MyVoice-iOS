//
//  SliderTableViewCell.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 31/01/2021.
//

import UIKit
import RxSwift

final class SliderTableViewCell: UITableViewCell {
    enum SliderDataType {
        case speechRate(currentValue: Float, minValue: Float, maxValue: Float)
        case speechPitch(currentValue: Float, minValue: Float, maxValue: Float)
    }
    
    @IBOutlet weak var defaultSlider: UISlider!
    lazy var disposeBag = DisposeBag()
    
    func setupSlider(for dataType: SliderDataType) {
        defaultSlider.tintColor = .orangeMain
        defaultSlider.minimumTrackTintColor = .orangeMain
        defaultSlider.maximumTrackTintColor = .blueLight
        defaultSlider.isContinuous = false
        selectionStyle = .none

        switch dataType {
        case .speechRate(let currentValue, let minValue, let maxValue):
            defaultSlider.minimumValue = minValue
            defaultSlider.minimumValueImage = UIImage(systemName: "tortoise.fill",
                                               withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            defaultSlider.maximumValue = maxValue
            defaultSlider.maximumValueImage = UIImage(systemName: "hare.fill",
                                               withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            defaultSlider.setValue(currentValue, animated: false)

        case .speechPitch(let currentValue, let minValue, let maxValue):
            defaultSlider.minimumValue = minValue
            defaultSlider.minimumValueImage = UIImage(systemName: "minus.circle.fill",
                                                      withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large))
            defaultSlider.maximumValue = maxValue
            defaultSlider.maximumValueImage = UIImage(systemName: "plus.circle.fill",
                                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large))
            defaultSlider.value = currentValue
        }
    }
    
    override func prepareForReuse() { disposeBag = DisposeBag() }
}
