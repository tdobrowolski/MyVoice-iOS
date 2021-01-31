//
//  SliderTableViewCell.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 31/01/2021.
//

import UIKit

final class SliderTableViewCell: UITableViewCell {
    
    enum SliderDataType {
        case speechRate(currentValue: Float, minValue: Float, maxValue: Float)
        case speechPitch(currentValue: Float)
    }
    
    var defaultSlider: UISlider!
    
    func setupSlider(for dataType: SliderDataType) {
        self.setSliderConstraints()
        self.defaultSlider.tintColor = UIColor(named: "Orange (Main)")
        self.defaultSlider.minimumTrackTintColor = UIColor(named: "Orange (Main)")
        self.defaultSlider.maximumTrackTintColor = UIColor(named: "Blue (Light)")
        self.defaultSlider.isUserInteractionEnabled = true
        self.defaultSlider.isContinuous = true
        self.contentView.isUserInteractionEnabled = true
        
        switch dataType {
        case .speechRate(let currentValue, let minValue, let maxValue):
            self.defaultSlider.minimumValue = minValue
            self.defaultSlider.minimumValueImage = UIImage(systemName: "tortoise.fill",
                                                    withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            self.defaultSlider.minimumValue = maxValue
            self.defaultSlider.maximumValueImage = UIImage(systemName: "hare.fill",
                                                    withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            self.defaultSlider.setValue(currentValue, animated: false)
        case .speechPitch(let currentValue):
            self.defaultSlider.minimumValue = 0.5
            self.defaultSlider.minimumValueImage = UIImage(systemName: "minus.circle.fill",
                                                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large))
            self.defaultSlider.minimumValue = 2.0
            self.defaultSlider.maximumValueImage = UIImage(systemName: "plus.circle.fill",
                                                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large))
            self.defaultSlider.value = currentValue
        }
    }
    
    private func setSliderConstraints() {
        if self.defaultSlider == nil {
            self.defaultSlider = UISlider(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            self.contentView.addSubview(self.defaultSlider)
            self.contentView.addConstraint(NSLayoutConstraint(item: self.defaultSlider!, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 16))
            self.contentView.addConstraint(NSLayoutConstraint(item: self.defaultSlider!, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -16))
            self.contentView.addConstraint(NSLayoutConstraint(item: self.defaultSlider!, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 6))
            self.contentView.addConstraint(NSLayoutConstraint(item: self.defaultSlider!, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -6))
            self.defaultSlider.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
