//
//  User.swift
//  APIHomework
//
//  Created by Артём Сноегин on 29.10.2025.
//

struct User: Decodable {
    
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: UserAdress
    let phone: String
    let website: String
    let company: UserCompany
}

struct UserAdress: Decodable {
    
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: UserGeo
}

struct UserGeo: Decodable {
    
    let lat: String
    let lng: String
}

struct UserCompany: Decodable {
    
    let name: String
    let catchPhrase: String
    let bs: String
}
