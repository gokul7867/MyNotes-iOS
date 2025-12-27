final class NoteListViewModel {

    private let repository: NoteRepository

    private var allNotes: [Note] = []
    private(set) var filteredNotes: [Note] = [] {
        didSet { onNotesUpdated?() }
    }

    var onNotesUpdated: (() -> Void)?

    init(repository: NoteRepository = NoteRepository()) {
        self.repository = repository
    }

    func loadNotes() {
        allNotes = repository.fetchNotes()
        filteredNotes = allNotes
    }

    func searchNotes(text: String) {
        applyFilters(searchText: text, onlyFavorites: currentOnlyFavorites)
    }

    // MARK: - Menu Filter
    private var currentOnlyFavorites = false
    func filterNotes(onlyFavorites: Bool) {
        currentOnlyFavorites = onlyFavorites
        applyFilters(searchText: currentSearchText, onlyFavorites: onlyFavorites)
    }

    private var currentSearchText = ""
    private func applyFilters(
        searchText: String,
        onlyFavorites: Bool
    ) {
        currentSearchText = searchText
        var result = allNotes
        if onlyFavorites {
            result = result.filter { $0.isFavorite }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.title?.lowercased().contains(searchText.lowercased()) ?? false ||
                $0.content?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        filteredNotes = result
    }

    func addNote(title: String, content: String) {
        repository.createNote(title: title, content: content)
        loadNotes()
    }

    func toggleFavorite(at index: Int) {
        let note = filteredNotes[index]
        note.isFavorite.toggle()
        repository.updateNote(note)
        loadNotes()
    }
    
    func deleteNote(at index: Int) {
        repository.deleteNote(filteredNotes[index])
        loadNotes()
    }
}
