//
//  PhraseDatabaseService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 14/02/2021.
//

import CoreData

final class PhraseDatabaseService: DatabaseService {

    // MARK: Create
    
    func insertPhrase(_ quickPhrase: QuickPhraseModel) {
        let phraseEntity = Phrase(context: context)
        phraseEntity.id = quickPhrase.id
        phraseEntity.phrase = quickPhrase.phrase
        phraseEntity.createdAt = quickPhrase.createdAt
        phraseEntity.prefferedLanguage = quickPhrase.prefferedLanguage
        
        context.insert(phraseEntity)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Read
    
    func fetchPhrase(with id: UUID) -> [QuickPhraseModel] {
        let request = NSFetchRequest<Phrase>(entityName: "Phrase")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let phrases = try context.fetch(request)

            return convertPhrasesToQuickPhrases(phrases: phrases)
        } catch {
            print(error.localizedDescription)
        }

        return []
    }
    
    func fetchAllPhrases() -> [QuickPhraseModel] {
        do {
            let phrases = try context.fetch(Phrase.fetchRequest() as NSFetchRequest<Phrase>)

            return convertPhrasesToQuickPhrases(phrases: phrases).reversed()
        } catch {
            print(error.localizedDescription)
        }

        return []
    }
    
    // MARK: Delete
    
    func removePhrase(_ quickPhrase: QuickPhraseModel) { deletePhrases(with: quickPhrase.id) }
    
    private func deletePhrases(with id: UUID) {
        let fetchRequest = Phrase.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Model conversion
    
    private func convertPhrasesToQuickPhrases(phrases: [Phrase]) -> [QuickPhraseModel] {
        var quickPhrases: [QuickPhraseModel] = []
        for phrase in phrases {
            let quickPhrase = QuickPhraseModel(id: phrase.id, phrase: phrase.phrase, createdAt: phrase.createdAt, prefferedLanguage: phrase.prefferedLanguage)
            quickPhrases.append(quickPhrase)
        }
        
        return quickPhrases
    }
}
