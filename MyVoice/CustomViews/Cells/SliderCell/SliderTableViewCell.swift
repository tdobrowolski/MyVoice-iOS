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
        self.defaultSlider.tintColor = UIColor(named: "Orange (Main)")
        self.defaultSlider.minimumTrackTintColor = UIColor(named: "Orange (Main)")
        self.defaultSlider.maximumTrackTintColor = UIColor(named: "Blue (Light)")
        self.defaultSlider.isContinuous = false
        self.selectionStyle = .none

        switch dataType {
        case .speechRate(let currentValue, let minValue, let maxValue):
            self.defaultSlider.minimumValue = minValue
            self.defaultSlider.minimumValueImage = UIImage(systemName: "tortoise.fill",
                                                    withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            self.defaultSlider.maximumValue = maxValue
            self.defaultSlider.maximumValueImage = UIImage(systemName: "hare.fill",
                                                    withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            self.defaultSlider.setValue(currentValue, animated: false)
        case .speechPitch(let currentValue, let minValue, let maxValue):
            self.defaultSlider.minimumValue = minValue
            self.defaultSlider.minimumValueImage = UIImage(systemName: "minus.circle.fill",
                                                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large))
            self.defaultSlider.maximumValue = maxValue
            self.defaultSlider.maximumValueImage = UIImage(systemName: "plus.circle.fill",
                                                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large))
            self.defaultSlider.value = currentValue
        }
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }
}
