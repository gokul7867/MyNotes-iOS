//
//  AddNoteViewController.swift
//  MyNotes
//
//  Created by gokul gokul on 26/12/25.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Title.."
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let subtitleTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.cornerRadius = 8
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let saveButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Save", for: .normal)
        bt.titleLabel?.font = .boldSystemFont(ofSize: 16)
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    
    var onNoteAdded: (() -> Void)?
    private let viewModel: AddNoteViewModel
    
    init(viewModel: AddNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Add Note"
        
        view.addSubview(titleTextField)
        view.addSubview(subtitleTextView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 12),
            subtitleTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            subtitleTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            subtitleTextView.heightAnchor.constraint(equalToConstant: 200),
            
            saveButton.topAnchor.constraint(equalTo: subtitleTextView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupAction(){
        saveButton.addTarget(self,
                     action: #selector(saveTapped),
                     for: .touchUpInside)
    }
    
    @objc private func saveTapped() {
        viewModel.saveNote(
            title: titleTextField.text ?? "",
            content: subtitleTextView.text ?? ""
        )
        onNoteAdded?()
        dismiss(animated: true)
    }
}
