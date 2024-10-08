//
//  SettingModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 30/01/2021.
//

import RxDataSources

struct SettingsSection {
    enum SectionType: String {
        case speechVoice = "speechVoice"
        case speechRate = "speechRate"
        case speechPitch = "speechPitch"
        case personalVoice = "personalVoice"
        case other = "other"
    }
    
    var type: SectionType
    var footer: String? = nil
    var items: [Item]
    
    var localizedHeaderString: String {
        switch type {
        case .speechVoice: return NSLocalizedString("Speech settings", comment: "Speech settings")
        case .speechRate: return NSLocalizedString("Speech rate", comment: "Speech rate")
        case .speechPitch: return NSLocalizedString("Speech pitch", comment: "Speech pitch")
        case .personalVoice: return NSLocalizedString("Personal Voice", comment: "Personal Voice")
        case .other: return NSLocalizedString("Other", comment: "Other")
        }
    }
}

extension SettingsSection: AnimatableSectionModelType {
    typealias Item = SettingModel
    
    var identity: String { type.rawValue }
    
    init(original: SettingsSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct SettingModel: IdentifiableType, Equatable {
    typealias Identity = UUID
    
    var identity: Identity { id }
        
    let id = UUID()
    let primaryText: String
    let secondaryText: String?
}

func ==(lhs: SettingModel, rhs: SettingModel) -> Bool {
    return lhs.id == rhs.id
}
