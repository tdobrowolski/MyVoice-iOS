//
//  Phrase+CoreDataProperties.swift
//  
//
//  Created by Tobiasz Dobrowolski on 10/02/2021.
//
//

import Foundation
import CoreData


extension Phrase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Phrase> {
        return NSFetchRequest<Phrase>(entityName: "Phrase")
    }

    @NSManaged public var id: UUID
    @NSManaged public var phrase: String
    @NSManaged public var createdAt: Date
    @NSManaged public var prefferedLanguage: String?

}
