//
//  TestCoreDataStack.swift
//  MyNotesTests
//
//  Created by gokul gokul on 27/12/25.
//

import Foundation
import CoreData

final class TestCoreDataStack {
    
    static let shared = TestCoreDataStack()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MyNotes")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    var context: NSManagedObjectContext {
           persistentContainer.viewContext
       }
}
