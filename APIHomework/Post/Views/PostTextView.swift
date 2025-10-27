//
//  PostView.swift
//  APIHomework
//
//  Created by Артём Сноегин on 26.10.2025.
//

import UIKit

class PostTextView: UIView {
    
    weak var delegate: PostTextViewDelegate?
    
    private var post: Post
    
    private let titleTextView = UITextView()
    private let titlePlaceholder = "Title"
    private var titlePlaceholderIsOn = false
    
    private let bodyTextView = UITextView()
    
    private let scrollView = UIScrollView()
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    
    private let stackView = UIStackView()

    init(post: Post = Post()) {
        
        self.post = post
        
        super.init(frame: .zero)
        setupUI()
        subscribeNotification()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func canEdit(_ bool: Bool = true) {
        
        titleTextView.isEditable = bool
        bodyTextView.isEditable = bool
    }
    
    func makeBodyTextViewFirstResponder() {
        
        titleTextView.resignFirstResponder()
        bodyTextView.becomeFirstResponder()
    }

    private func setupUI() {
        
        backgroundColor = .systemBackground

        titleTextView.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        titleTextView.isScrollEnabled = false
        titleTextView.isEditable = false
        
        titleTextView.delegate = self

        if post.title.isEmpty {
            
            titleTextView.text = titlePlaceholder
            titleTextView.textColor = .secondaryLabel
            titlePlaceholderIsOn = true
            
        } else {
            
            titleTextView.text = post.title
            titleTextView.textColor = .label
        }
        
        let divider = Divider()
        
        bodyTextView.font = .preferredFont(forTextStyle: .title3)
        bodyTextView.isScrollEnabled = false
        bodyTextView.isEditable = false
        
        bodyTextView.delegate = self
        
        bodyTextView.text = post.body
        bodyTextView.textColor = .label
        
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        
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
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        stackView.addArrangedSubview(titleTextView)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(bodyTextView)
    }
    
    func subscribeNotification() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
            scrollView.contentInset.bottom = keyboardFrame.height
            layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        scrollView.contentInset.bottom = 0
        layoutIfNeeded()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension PostTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        guard textView == titleTextView else { return }

        if titlePlaceholderIsOn {
            
            textView.text = ""
            textView.textColor = .label
            titlePlaceholderIsOn = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard textView == titleTextView else { return }
        
        if textView.text.isEmpty {
            
            textView.text = titlePlaceholder
            textView.textColor = .secondaryLabel
            titlePlaceholderIsOn = true
        }
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        guard textView == titleTextView else { return true }
            
        if text == "\n" {
            
            bodyTextView.becomeFirstResponder()
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if !titlePlaceholderIsOn {
            
            post.title = titleTextView.text
            post.body = bodyTextView.text
            delegate?.didChange(post: post)
        }
    }
}
