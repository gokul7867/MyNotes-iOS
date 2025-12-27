//
//  PersistenceController.swift
//  MyNotes
//
//  Created by gokul gokul on 26/12/25.
//

import Foundation
import CoreData

final class PersistenceController {
    
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    private init() {
        container = NSPersistentContainer(name: "MyNotes")
        container.loadPersistentStores { _,error in
            if let error = error {
                fatalError("Core Data load failed: \(error)")
            }
        }
    }
    var context: NSManagedObjectContext {
        container.viewContext
    }
}
