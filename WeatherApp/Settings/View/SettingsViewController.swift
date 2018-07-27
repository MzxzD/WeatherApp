//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RxSwift

class SettingsViewController: UIViewController {

    let disposeBag = DisposeBag()
    var settingsViewModel: SettingsViewModel!
    var alert = UIAlertController()
    let cellIdentifier = "WeatherViewCell"
    
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_uncheck"), for: .normal)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Book", size: 72)
        label.text = "27"
        label.textColor = UIColor.white
        label.text = "Testing!"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupView()
    }

    
    func setupView(){
        
        view.addSubview(doneButton)
        doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(testLabel)
        testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        testLabel.centerYAnchor.constraint(equalTo: doneButton.topAnchor, constant: 150).isActive = true
    }

    @objc func doneButtonPressed() {
        self.settingsViewModel.dissmissTheView()
    }
    
}
