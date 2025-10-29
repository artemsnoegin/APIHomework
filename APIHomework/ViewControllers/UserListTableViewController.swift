//
//  UserListTableViewController.swift
//  APIHomework
//
//  Created by Артём Сноегин on 29.10.2025.
//

import UIKit

class UserListTableViewController: UITableViewController {
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsers()
        
        title = "Users"
        
        tableView.allowsSelection = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseId)
    }
    
    private func loadUsers() {
        
        UserFetcher().fetchUsers() { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let users):
                    
                    self?.users = users
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    
                    print("Error fetching users: \(error)")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseId, for: indexPath) as! UserTableViewCell
        cell.configure(for: user)
        
        return cell
    }
}


