//
//  DatabaseService.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 10/02/2021.
//

import UIKit
import CoreData

class DatabaseService {
    private let persistanceContainer = NSPersistentContainer(name: "Model")
    
    init() { initializeStack() }
    
    func initializeStack() {
        persistanceContainer.loadPersistentStores { description, error in
            if let error = error {
                return print(error.localizedDescription)
            }
        }
    }
    
    var context: NSManagedObjectContext { persistanceContainer.viewContext }
    
    // MARK: CoreData methods
    
    func delete(object: NSManagedObject) {
        context.delete(object)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
