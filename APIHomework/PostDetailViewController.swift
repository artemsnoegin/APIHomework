//
//  PostDetailViewController.swift
//  APIHomework
//
//  Created by Артём Сноегин on 25.10.2025.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var didUpdatePost: ((Post) -> Void)?
    
    private var post: Post
    
    private let titleTextView = UITextView()
    private let bodyTextView = UITextView()
    
    init(post: Post) {
        
        self.post = post
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
        configureNavigationBar()
    }
    
    private func setupUI() {

        titleTextView.text = post.title
        titleTextView.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        titleTextView.isScrollEnabled = false
        titleTextView.isEditable = false
        
        bodyTextView.text = post.body
        bodyTextView.font = .preferredFont(forTextStyle: .body)
        bodyTextView.isScrollEnabled = false
        bodyTextView.isEditable = false
        
        let stackView = UIStackView(arrangedSubviews: [titleTextView, bodyTextView])
        stackView.axis = .vertical
        stackView.spacing = 0
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureNavigationBar() {
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        titleTextView.isEditable = editing
        bodyTextView.isEditable = editing

        if editing {
            
            bodyTextView.becomeFirstResponder()
            editButtonItem.tintColor = .systemGreen
            
        } else {
            
            view.endEditing(true)
            editButtonItem.tintColor = .label
            
            post.title = titleTextView.text
            post.body = bodyTextView.text
            didUpdatePost?(post)
        }
    }
}
