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
    
    private let postView = PostTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupPostView()
        configureNavigationBar()
    }

    private func setupPostView() {
        
        postView.canEdit()

        postView.delegate = self
        
        view.addSubview(postView)
        postView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            postView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            postView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        
        title = "New Post"
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
