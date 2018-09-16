//
//  CellHeaderFooterView.swift
//  WeatherApp
//
//  Created by Mateo Doslic on 16/09/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit

class CellHeaderFooterView: UITableViewHeaderFooterView {
    
    let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.addSubviews(sectionTitleLabel)
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        setupConstraints()
    }
    
    private func setupConstraints(){
        
        let constraints = [
            
            sectionTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            sectionTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
