//
//  QuickPhraseModel.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 20/01/2021.
//

import RxDataSources

struct QuickPhraseSection {
    var header = "Quick access"
    var items: [Item]
}

extension QuickPhraseSection: AnimatableSectionModelType {
    typealias Item = QuickPhraseModel
    
    var identity: String { header }
    
    init(original: QuickPhraseSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct QuickPhraseModel: IdentifiableType, Equatable {
    typealias Identity = UUID
    
    var identity: Identity { id }
        
    let id: UUID
    let phrase: String
    let createdAt: Date
    let prefferedLanguage: String?
    
    init(
        id: UUID = UUID(),
        phrase: String,
        createdAt: Date,
        prefferedLanguage: String? = nil
    ) {
        self.id = id
        self.phrase = phrase
        self.createdAt = createdAt
        self.prefferedLanguage = prefferedLanguage
    }
}

func ==(lhs: QuickPhraseModel, rhs: QuickPhraseModel) -> Bool {
    return lhs.id == rhs.id
}
