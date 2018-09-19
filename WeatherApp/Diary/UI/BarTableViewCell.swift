//
//  BarTableViewCell.swift
//  WeatherApp
//
//  Created by Mateo Doslic on 19/09/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit
import Charts

class BarTableViewCell: UITableViewCell {

    
    let chart : BarChartView = {
        let chart = BarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        return chart
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()

    }
    
    private func setupUI(){
        self.contentView.addSubviews(chart)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        setupConstraints()
    }
    
    private func setupConstraints(){
        let constraints = [
                    contentView.heightAnchor.constraint(equalToConstant: 200),
                    chart.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    chart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                    chart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                    chart.heightAnchor.constraint(equalToConstant: 150),
            ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
