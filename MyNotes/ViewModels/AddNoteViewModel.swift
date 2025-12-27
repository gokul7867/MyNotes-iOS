//
//  AddNoteViewModel.swift
//  MyNotes
//
//  Created by gokul gokul on 26/12/25.
//

import Foundation

final class AddNoteViewModel {

    private let repository: NoteRepository

    init(repository: NoteRepository = NoteRepository()) {
        self.repository = repository
    }

    func saveNote(title: String, content: String) {
        repository.createNote(title: title, content: content)
    }
}
