//
//  PostNetworkService.swift
//  APIHomework
//
//  Created by Артём Сноегин on 25.10.2025.
//

import Foundation

class PostNetworkService {
    
    private let urlString = "https://jsonplaceholder.typicode.com/posts"
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data else { return }
            
            do {
                
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
                
            } catch {
                
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    func createNewPost(_ post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONEncoder().encode(post)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                
                do {
                    
                    let post = try JSONDecoder().decode(Post.self, from: data)
                    completion(.success(post))
                    
                } catch {
                    
                    completion(.failure(error))
                }
            }
        }
        
        dataTask.resume()
    }
    
    func updatePost(_ post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        
        let idString = String(post.id)
        
        guard let url = URL(string: urlString + "/" + idString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONEncoder().encode(post)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                
                do {
                    
                    let post = try JSONDecoder().decode(Post.self, from: data)
                    completion(.success(post))
                    
                } catch {
                    
                    completion(.failure(error))
                }
            }
        }
        
        dataTask.resume()
    }
    
    func deletePost(_ post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let idString = String(post.id)
        
        guard let url = URL(string: urlString + "/" + idString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let dataTask = URLSession.shared.dataTask(with: request) { _, _, error in
            
            if let error = error {
                
                completion(.failure(error))
            }
            
            completion(.success(()))
        }
        
        dataTask.resume()
    }
}
