//
//  Post.swift
//  APIHomework
//
//  Created by Артём Сноегин on 25.10.2025.
//

struct Post: Codable {
    
    let id: Int
    let userId: Int
    var title: String
    var body: String
    
    init(id: Int = 0, userId: Int = 0, title: String = "", body: String = "") {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}
