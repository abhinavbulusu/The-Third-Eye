//
//  ScanImage.swift
//  The Third Eye
//
//  Created by Abhinav Bulusu on 7/22/22.
//

import UIKit
 
class ScanImageView: UIImageView {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 7.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemIndigo.cgColor
        backgroundColor = UIColor.init(white: 1.0, alpha: 0.1)
        clipsToBounds = true
    }
}
