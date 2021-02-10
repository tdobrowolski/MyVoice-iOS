//
//  DatabaseService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 10/02/2021.
//

import UIKit
import CoreData

class DatabaseService {
    
    let persistanceContainer = NSPersistentContainer(name: "Model")
    
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
    
    func fetchAllPhrases() {
        do {
            let phrases = try self.context.fetch(Phrase.fetchRequest() as NSFetchRequest<Phrase>)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchPhrase(withID: UUID) {
        let request = NSFetchRequest<Phrase>(entityName: "Phrase")
        request.predicate = NSPredicate(format: "id == %@", withID as CVarArg)
        
        do {
            let phrases = try self.context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(phrase: Phrase) {
        self.context.delete(phrase)
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteUsers(withID: UUID) {
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
