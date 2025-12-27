//
//  NoteListViewController.swift
//  MyNotes
//
//  Created by gokul gokul on 26/12/25.
//

import Foundation
import UIKit

class NoteListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        tableView.register(
            NoteCell.self,
            forCellReuseIdentifier: "NoteCell"
        )
        return tableView
    }()
    
    private let viewModel = NoteListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadNotes()
        setupFilterMenu()
    }
    
    func setupUI(){
        view.backgroundColor = .white
        title = "Notes"
        
        tableView.dataSource = self
        tableView.delegate = self
        setupGestures()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNoteTapped)
        )
        
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onNotesUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func addNoteTapped() {
        let viewModel = AddNoteViewModel()
        let addVC = AddNoteViewController(viewModel: viewModel)

        addVC.onNoteAdded = { [weak self] in
            self?.viewModel.loadNotes()
        }

        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }

    private func setupFilterMenu() {
        let allAction = UIAction(title: "All", image: UIImage(systemName: "list.bullet")) { [weak self] _ in
            self?.viewModel.filterNotes(onlyFavorites: false)
        }

        let favoritesAction = UIAction(title: "Favorites", image: UIImage(systemName: "star.fill")) { [weak self] _ in
            self?.viewModel.filterNotes(onlyFavorites: true)
        }

        let menu = UIMenu(title: "Filter", options: .displayInline, children: [allAction, favoritesAction])
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", menu: menu)
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            // Toggle favorite in ViewModel
            viewModel.toggleFavorite(at: indexPath.row)
        }
    }
    
    private func setupGestures() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(doubleTap)
    }
}

extension NoteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredNotes.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "NoteCell",
            for: indexPath
        ) as? NoteCell else {
            return UITableViewCell()
        }
        let note = viewModel.filteredNotes[indexPath.row]
        cell.configure(with: note)
        return cell
    }
    
}

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.deleteNote(at: indexPath.row)
        }
    }
    
}

extension NoteListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchNotes(text: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchNotes(text: "")
    }
}
