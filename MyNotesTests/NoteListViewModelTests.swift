//
//  NoteListViewModelTests.swift
//  MyNotesTests
//
//  Created by gokul gokul on 27/12/25.
//

import Foundation
import XCTest
@testable import MyNotes

final class NoteListViewModelTests: XCTestCase {
    
    var viewModel: NoteListViewModel!
    var repository: NoteRepository!
    
    override func setUp() {
        super.setUp()
        let context = TestCoreDataStack.shared.context
        repository = NoteRepository(context: context)
        viewModel = NoteListViewModel(repository: repository)
    }
    
    override func tearDown() {
        viewModel = nil
        repository = nil
        super.tearDown()
    }
    
    func testAddNote() {
        repository.createNote(
            title: "Unit Test",
            content: "Testing Core Data",
        )

        viewModel.loadNotes()

        XCTAssertEqual(viewModel.filteredNotes.count, 1)
        XCTAssertEqual(viewModel.filteredNotes.first?.title, "Unit Test")
    }
    func testToggleFavorite() {
        repository.createNote(
            title: "Fav Note",
            content: "Tap twice",
        )

        viewModel.loadNotes()
        viewModel.toggleFavorite(at: 0)

        let note = viewModel.filteredNotes.first
        XCTAssertTrue(note?.isFavorite == true)
    }

}
