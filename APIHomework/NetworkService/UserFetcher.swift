//
//  UserFetcher.swift
//  APIHomework
//
//  Created by Артём Сноегин on 29.10.2025.
//

import Foundation

class UserFetcher {
    
    private let urlString = "https://jsonplaceholder.typicode.com/users"
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            
            print("Error fetching users: Wrong URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard let data = data else {
                
                print("Error fetching users: no data(nil)")
                return
            }
            
            do {
                
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            }
            catch {
                
                print("Error decoding users")
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}
