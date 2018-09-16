//
//  WeatherViewCell.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit

class CityViewCell: UITableViewCell {

    
    var cityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImage(named: "square_checkmark_uncheck") as UIImage?
        imageView.image = icon
        return imageView
    }()
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    var cityLetterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
          label.textColor = .white
        return label
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(cityImageView)
        self.contentView.addSubview(cityLabel)
        
        cityImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cityImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cityImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cityImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        cityImageView.addSubview(cityLetterLabel)
        cityLetterLabel.centerXAnchor.constraint(equalTo: cityImageView.centerXAnchor).isActive = true
        cityLetterLabel.centerYAnchor.constraint(equalTo: cityImageView.centerYAnchor).isActive = true
        
        cityLabel.centerYAnchor.constraint(equalTo: cityImageView.centerYAnchor).isActive = true
        cityLabel.leadingAnchor.constraint(equalTo: cityImageView.trailingAnchor, constant: 8).isActive = true
        cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
