//
//  PostDetailViewController.swift
//  APIHomework
//
//  Created by Артём Сноегин on 25.10.2025.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var completion: ((Post) -> Void)?
    
    private var post: Post
    
    private var postView = PostView()
    
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
        
        configureNavigationBar()
        setupPostView()
    }

    private func setupPostView() {
        
        postView = PostView(postTitle: post.title, postBody: post.body)
        postView.canEdit(false)
        
        postView.delegate = self
        
        view.addSubview(postView)
        postView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            postView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            postView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        postView.canEdit(editing)

        if editing {
            
//            bodyTextView.becomeFirstResponder()
            editButtonItem.tintColor = .systemGreen
            
        } else {
            
            completion?(post)
            view.endEditing(true)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension PostDetailViewController: PostViewDelegate {
    
    func didChange(post: Post) {
        
        if post.title.isEmpty && post.body.isEmpty {

            editButtonItem.isEnabled = false
                
        } else {
            
            editButtonItem.isEnabled = true
            
            self.post.title = post.title
            self.post.body = post.body
        }
    }
}
