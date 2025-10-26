//
//  PostCreateViewController.swift
//  APIHomework
//
//  Created by Артём Сноегин on 26.10.2025.
//

import UIKit

class PostCreateViewController: UIViewController {
    
    var completion: ((Post) -> Void)?
    
    private let postView = PostView()
    private var post = Post(title: "", body: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupPostView()
        configureNavigationBar()
    }

    private func setupPostView() {

        postView.canEdit(true)
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePost))
        navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    @objc private func savePost() {
        
        completion?(post)
        navigationController?.popViewController(animated: true)
    }
}

extension PostCreateViewController: PostViewDelegate {
    
    func didChange(post: Post) {
        
        if post.title.isEmpty && post.body.isEmpty {
            
            navigationItem.rightBarButtonItem?.isHidden = true
            
        } else {
            
            navigationItem.rightBarButtonItem?.isHidden = false
            self.post = post
        }
    }
}
