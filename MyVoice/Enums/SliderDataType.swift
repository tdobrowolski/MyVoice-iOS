//
//  SliderDataType.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/06/2023.
//

import AVFoundation

enum SliderDataType {
    case speechRate(currentValue: Float)
    case speechPitch(currentValue: Float)
    
    static var defaultSpeechRateValue: Float { AVSpeechUtteranceDefaultSpeechRate }
    static var minSpeechRateValue: Float { AVSpeechUtteranceMinimumSpeechRate }
    static var maxSpeechRateValue: Float { AVSpeechUtteranceMaximumSpeechRate }
    static var defaultAdjustmentRateRange: ClosedRange<Float> {
        let allowedDisplacement = defaultSpeechRateValue * 0.04
        
        return (defaultSpeechRateValue - allowedDisplacement)...(defaultSpeechRateValue + allowedDisplacement)
    }
    
    static var defaultSpeechPitchValue: Float { 1.0 }
    static var minSpeechPitchValue: Float { 0.0 }
    static var maxSpeechPitchValue: Float { 2.0 }
    static var defaultAdjustmentPitchRange: ClosedRange<Float> {
        let allowedDisplacement = defaultSpeechPitchValue * 0.04
        
        return (defaultSpeechPitchValue - allowedDisplacement)...(defaultSpeechPitchValue + allowedDisplacement)
    }
}
