//
//  DetailPostViewController.swift
//  APIHomework
//
//  Created by Артём Сноегин on 25.10.2025.
//

import UIKit

class DetailPostViewController: UIViewController {
    
    var didEditPost: ((Post) -> Void)?
    
    private var post: Post
    
    private var postTextView = PostTextView()
    
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
        
        setupPostView()
        configureNavigationBar()
    }

    private func setupPostView() {
        
        postTextView = PostTextView(post: post)
        
        postTextView.delegate = self
        
        view.addSubview(postTextView)
        postTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            postTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            postTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        postTextView.canEdit()

        if editing {
            
            postTextView.makeBodyTextViewFirstResponder()
            editButtonItem.tintColor = .systemGreen
            
        } else {
            
            view.endEditing(true)
            didEditPost?(post)
            editButtonItem.tintColor = .label
        }
    }
}

extension DetailPostViewController: PostTextViewDelegate {
    
    func didChange(post: Post) {
        
        if !post.title.isEmpty && !post.body.isEmpty {

            editButtonItem.isEnabled = true
            
            self.post.title = post.title
            self.post.body = post.body
                
        } else {
            
            editButtonItem.isEnabled = false
        }
    }
}
