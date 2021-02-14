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
    
    // MARK: CoreData methods
    
    func delete(object: NSManagedObject) {
        self.context.delete(object)
        do {
            try self.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
