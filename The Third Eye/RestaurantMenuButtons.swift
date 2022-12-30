//
//  RestaurantMenuButtons.swift
//  The Third Eye
//
//  Created by Abhinav Bulusu on 7/31/22.
//

import UIKit
 class RestaurantMenuButtons: UIButton {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 11.0)
        titleLabel?.textColor = .white
        layer.cornerRadius = 4.0
        backgroundColor = UIColor.systemIndigo
    }
    
    
}
