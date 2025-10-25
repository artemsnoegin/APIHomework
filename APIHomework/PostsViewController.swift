//
//  PostsViewController.swift
//  APIHomework
//
//  Created by Артём Сноегин on 25.10.2025.
//

import UIKit

class PostsViewController: UIViewController {
    
    private let tableView = UITableView()
    private var posts = [Post]()
    
    private var networkService = PostNetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        loadPosts()
        
        configureNavigationBar()
        configureTableView()
    }
    
    private func loadPosts() {
        
        networkService.fetchPosts { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let posts):
                    
                    self?.posts = posts
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    
                    print("Error fetching posts: \(error)")
                }
            }
        }
    }
    
    private func configureNavigationBar() {
        
        title = "Posts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewPost))
    }
    
    @objc private func createNewPost() {
        
        let newPost = Post(title: "New Post", body: "Hello World")
        
        networkService.createNewPost(newPost) { [weak self] result in
            
            switch result {
                
            case .success(let post):
                
                self?.posts.append(post)
                self?.tableView.reloadData()
                
            case .failure(let error):
                
                print("Failed creating new post: \(error)")
            }
        }
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let post = posts[indexPath.row]
        
        var contentConfiguration = cell.defaultContentConfiguration()
        
        contentConfiguration.text = "Post \(post.id): \(post.title)"
        contentConfiguration.textProperties.numberOfLines = 1
        contentConfiguration.secondaryText = post.body
        contentConfiguration.secondaryTextProperties.numberOfLines = 2
        
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let post = posts[indexPath.row]
        
        let detailViewController = PostDetailViewController(post: post)
        
        detailViewController.didUpdatePost = { [weak self] post in
            
            self?.networkService.updatePost(post) { [weak self] result in
                
                switch result {
                    
                case .success(let post):
                    
                    self?.posts[indexPath.row] = post
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    
                    print("Couldn't update post: \(error)")
                }
            }
        }
        
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        let post = posts[indexPath.row]
        
        networkService.deletePost(post) { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success():
                    
                    self?.posts.remove(at: indexPath.row)
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    
                    print("Failed deleting post: \(error)")
                }
            }
        }
    }
}
