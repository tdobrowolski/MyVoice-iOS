//
//  SettingModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 30/01/2021.
//

import RxDataSources

struct SettingsSection {
    
    enum SectionType: String {
        case speechLanguage = "Speech settings"
        case speechRate = "Speech rate"
        case speechPitch = "Speech pitch"
        case other = "Other"
    }
    
    var type: SectionType
    var footer: String? = nil
    var items: [Item]
}

extension SettingsSection: AnimatableSectionModelType {
    typealias Item = SettingModel
    
    var identity: String {
        return type.rawValue
    }
    
    init(original: SettingsSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct SettingModel: IdentifiableType, Equatable {
    typealias Identity = UUID
    
    var identity: Identity { return id }
        
    let id = UUID()
    let primaryText: String
    let secondaryText: String?
}

func ==(lhs: SettingModel, rhs: SettingModel) -> Bool {
    return lhs.id == rhs.id
}
