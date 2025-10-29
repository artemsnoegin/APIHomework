//
//  UserTableViewCell.swift
//  APIHomework
//
//  Created by Артём Сноегин on 29.10.2025.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reuseId = "UserTableViewCell"
    
    private let nameLabel = UILabel()
    
    private let infoStack = UIStackView()
    
    private let usernameLabel = UILabel()
    private let emailLabel = UILabel()
    private let phoneLabel = UILabel()
    private let websiteLabel = UILabel()
    private let addressLabel = UILabel()
    private let companyLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for user: User) {
        
        nameLabel.text = user.name
    
        usernameLabel.text = "Username: \(user.username)"
        emailLabel.text = "Email: \(user.email)"
        phoneLabel.text = "Phone: \(user.phone)"
        websiteLabel.text = "Website: \(user.website)"
        addressLabel.text = "Adress: \(user.address.city), \(user.address.street), \(user.address.suite)"
        companyLabel.text = "Company: \(user.company.name)\n'\(user.company.catchPhrase)'"
    }
    
    private func setupUI() {
        
        nameLabel.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        nameLabel.textAlignment = .center
 
        infoStack.axis = .vertical
        infoStack.spacing = 4

        [usernameLabel, emailLabel, phoneLabel, websiteLabel, addressLabel, companyLabel].forEach {
            $0.font = .preferredFont(forTextStyle: .body)
            $0.numberOfLines = 0
            
            infoStack.addArrangedSubview($0)
        }
        
        [nameLabel, infoStack].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: infoStack.topAnchor, constant: -16),
            
            infoStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            infoStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            infoStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
