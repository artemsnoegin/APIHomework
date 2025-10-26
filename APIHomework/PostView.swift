//
//  PostView.swift
//  APIHomework
//
//  Created by Артём Сноегин on 26.10.2025.
//

import UIKit

class PostView: UIView {
    
    weak var delegate: PostViewDelegate?

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let titleTextView = UITextView()
    private let bodyTextView = UITextView()
    
    private let titlePlaceholder = "Title"
    private var postTitle: String?
    private var postBody: String?

    init(postTitle: String? = nil, postBody: String? = nil) {
        
        self.postTitle = postTitle
        self.postBody = postBody
        
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func canEdit(_ bool: Bool) {
        
        titleTextView.isEditable = bool
        bodyTextView.isEditable = bool
    }

    private func setupUI() {
        
        backgroundColor = .systemBackground

        titleTextView.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        titleTextView.isScrollEnabled = false
        
        titleTextView.isEditable = false
        
        titleTextView.delegate = self

        if let postTitle {
            
            titleTextView.text = postTitle
            titleTextView.textColor = .label
            
        } else {
            
            titleTextView.text = titlePlaceholder
            titleTextView.textColor = .secondaryLabel
        }
        
        let divider = UIView()
        divider.backgroundColor = .separator
        divider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        divider.layer.cornerRadius = 1.5
        divider.clipsToBounds = true

        bodyTextView.font = .preferredFont(forTextStyle: .title3)
        bodyTextView.isScrollEnabled = false
        
        bodyTextView.isEditable = false
        
        bodyTextView.delegate = self

        if let postBody {
            
            bodyTextView.text = postBody
            bodyTextView.textColor = .label
        }
        
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        stackView.addArrangedSubview(titleTextView)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(bodyTextView)
    }
}

extension PostView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        guard textView == titleTextView else { return }

        if postTitle == nil {
            
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard textView == titleTextView else { return }
        
        if textView.text.isEmpty {
            
            textView.text = titlePlaceholder
            textView.textColor = .secondaryLabel
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        delegate?.didChange(post: Post(title: titleTextView.text, body: bodyTextView.text))
    }
}
