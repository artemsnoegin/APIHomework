//
//  Divider.swift
//  APIHomework
//
//  Created by Артём Сноегин on 27.10.2025.
//

import UIKit

class Divider: UIView {
    
    let thickness: CGFloat
    
    init(thickness: CGFloat = 2, color: UIColor = .separator) {
        
        self.thickness = thickness
        super.init(frame: .zero)
        
        backgroundColor = color
        heightAnchor.constraint(equalToConstant: thickness).isActive = true
        layer.cornerRadius = thickness / 2
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
