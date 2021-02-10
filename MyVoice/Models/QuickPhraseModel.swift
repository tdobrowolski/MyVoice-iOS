//
//  QuickPhraseModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 20/01/2021.
//

import RxDataSources

struct QuickPhraseSection {
    
    var header: String = "Quick access"
    var items: [Item]
}

extension QuickPhraseSection: AnimatableSectionModelType {
    typealias Item = QuickPhraseModel
    
    var identity: String {
        return header
    }
    
    init(original: QuickPhraseSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct QuickPhraseModel: IdentifiableType, Equatable {
    typealias Identity = UUID
    
    var identity: Identity { return id }
        
    let id = UUID()
    let phrase: String
    let createdAt: Date
    let prefferedLanguage: String?
}

func ==(lhs: QuickPhraseModel, rhs: QuickPhraseModel) -> Bool {
    return lhs.id == rhs.id
}
