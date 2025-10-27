//
//  PostFeedTableViewController.swift
//  APIHomework
//
//  Created by Артём Сноегин on 25.10.2025.
//

import UIKit

class PostFeedTableViewController: UITableViewController {
    
    private var posts = [Post]()
    private var networkService = PostNetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        loadPosts()
        configureNavigationBar()
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
        
        let createPostViewController = CreatePostViewController()
        
        createPostViewController.completion = { [weak self] post in
            
            self?.networkService.createNewPost(post) { result in
                
                switch result {
                    
                case .success(let post):
                    
                    self?.posts.append(post)
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    
                    print("Failed creating new post: \(error)")
                }
            }
        }
        
        navigationController?.pushViewController(createPostViewController, animated: true)
    }
}

extension PostFeedTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        var contentConfiguration = cell.defaultContentConfiguration()
        
        contentConfiguration.text = "Post \(post.id): \(post.title)"
        contentConfiguration.textProperties.numberOfLines = 1
        
        contentConfiguration.secondaryText = post.body
        contentConfiguration.secondaryTextProperties.numberOfLines = 2
        
        cell.contentConfiguration = contentConfiguration
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedPost = posts[indexPath.row]
        
        let detailPostViewController = DetailPostViewController(post: selectedPost)
        
        detailPostViewController.didEditPost = { [weak self] updatedPost in
            
            self?.networkService.updatePost(updatedPost) { result in
                
                switch result {
                    
                case .success(let updatedPostFromServer):
                    
                    self?.posts[indexPath.row] = updatedPostFromServer
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    
                    print("Couldn't update post: \(error)")
                }
            }
        }
        
        navigationController?.pushViewController(detailPostViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        let postToDelete = posts[indexPath.row]
        
        networkService.deletePost(postToDelete) { [weak self] result in
            
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
