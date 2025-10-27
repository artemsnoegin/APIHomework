//
//  CreatePostViewController.swift
//  APIHomework
//
//  Created by Артём Сноегин on 26.10.2025.
//

import UIKit

class CreatePostViewController: UIViewController {
    
    var completion: ((Post) -> Void)?
    
    private var newPost = Post()
    
    private let postTextView = PostTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupPostView()
        configureNavigationBar()
    }

    private func setupPostView() {
        
        postTextView.canEdit()

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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePost))
        navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    @objc private func savePost() {
        
        completion?(newPost)
        navigationController?.popViewController(animated: true)
    }
}

extension CreatePostViewController: PostTextViewDelegate {
    
    func didChange(post: Post) {
        
        if !post.title.isEmpty && !post.body.isEmpty {
        
            navigationItem.rightBarButtonItem?.isHidden = false
            self.newPost = post
            
        } else {
            
            navigationItem.rightBarButtonItem?.isHidden = true
        }
    }
}
