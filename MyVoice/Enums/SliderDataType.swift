//
//  SliderDataType.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/06/2023.
//

import AVKit

enum SliderDataType {
    case speechRate(currentValue: Float, minValue: Float, maxValue: Float)
    case speechPitch(currentValue: Float, minValue: Float, maxValue: Float)
    
    static var defaultSpeechRateValue: Float { AVSpeechUtteranceDefaultSpeechRate }
    
    static var defaultSpeechPitchValue: Float { 1.0 }
}
