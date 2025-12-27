//
//  NoteRepository.swift
//  MyNotes
//
//  Created by gokul gokul on 26/12/25.
//

import Foundation
import CoreData

final class NoteRepository {
    
    private let context: NSManagedObjectContext
    
    init(
        context: NSManagedObjectContext = PersistenceController.shared.context
    ) {
        self.context = context
    }
    
    func createNote(
        title: String,
        content: String
    ){
        let note = Note(context: context)
        note.title = title
        note.content = content
        note.createdAt = Date()
        note.updatedAt = Date()
        note.isFavorite = false
        saveContext()
    }
    
    func fetchNotes() -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        return (try? context.fetch(request)) ?? []
    }
    
    func updateNote(_ note: Note) {
        note.isFavorite = note.isFavorite
        saveContext()
    }
    
    func deleteNote(_ note: Note){
        context.delete(note)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }
}
