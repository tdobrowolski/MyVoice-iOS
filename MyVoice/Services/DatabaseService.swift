//
//  DatabaseService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 10/02/2021.
//

import UIKit
import CoreData

class DatabaseService {
    
    // TODO: Clean up naming
    
    let persistanceContainer = NSPersistentContainer(name: "Model")
    
    init() {
        self.initializeStack()
    }
    
    func initializeStack() {
        self.persistanceContainer.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return self.persistanceContainer.viewContext
    }
    
    func insertPhrase(_ quickPhrase: QuickPhraseModel) {
        let phraseEntity = Phrase(context: context)
        phraseEntity.id = quickPhrase.id
        phraseEntity.phrase = quickPhrase.phrase
        phraseEntity.createdAt = quickPhrase.createdAt
        phraseEntity.prefferedLanguage = quickPhrase.prefferedLanguage
        
        self.context.insert(phraseEntity)
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAllPhrases() -> [QuickPhraseModel] {
        do {
            let phrases = try self.context.fetch(Phrase.fetchRequest() as NSFetchRequest<Phrase>)
            return self.convertPhrasesToQuickPhrases(phrases: phrases)
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func removePhrase(_ quickPhrase: QuickPhraseModel) {
        self.deletePhrases(withID: quickPhrase.id)
    }
    
    private func convertPhrasesToQuickPhrases(phrases: [Phrase]) -> [QuickPhraseModel] {
        var quickPhrases: [QuickPhraseModel] = []
        for phrase in phrases {
            let quickPhrase = QuickPhraseModel(phrase: phrase.phrase, createdAt: phrase.createdAt, prefferedLanguage: phrase.prefferedLanguage) // FIXME: ID should be passed too
            quickPhrases.append(quickPhrase)
        }
        return quickPhrases
    }
    
    // MARK: CoreData methods
    
    func fetchPhrase(withID: UUID) -> [QuickPhraseModel] {
        let request = NSFetchRequest<Phrase>(entityName: "Phrase")
        request.predicate = NSPredicate(format: "id == %@", withID as CVarArg)
        
        do {
            let phrases = try self.context.fetch(request)
            return self.convertPhrasesToQuickPhrases(phrases: phrases)
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func delete(phrase: Phrase) {
        self.context.delete(phrase)
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deletePhrases(withID: UUID) {
        let fetchRequest = Phrase.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        fetchRequest.predicate = NSPredicate(format: "id == %@", withID as CVarArg)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.context.execute(deleteRequest)
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
