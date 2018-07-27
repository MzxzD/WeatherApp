//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RxSwift

class SearchViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    let disposeBag = DisposeBag()
    var searchViewModel: SearchViewModel!
    var alert = UIAlertController()
     let cellIdentifier = "WeatherViewCell"
    
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_uncheck"), for: .normal)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var searchTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        view.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect )
//        view.backgroundView = blurEffectView
        view.backgroundColor = .gray
        return view
    }()

    var searchBar: UISearchBar = {
        let searchBar = UISearchBar ()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        searchBar.layer.cornerRadius = 18
        searchBar.clipsToBounds = true
        
        let searchTextField = searchBar.value(forKey: "searchField") as! UITextField
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        searchTextField.layer.cornerRadius = 15
        searchTextField.textAlignment = NSTextAlignment.left
        searchTextField.leftView = nil
        searchTextField.placeholder = "Search"
        
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        self.setupView()
        searchTableView.register(CityViewCell.self, forCellReuseIdentifier: cellIdentifier)
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.becomeFirstResponder()
        
    }
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityViewCell else
        {
            errorOccured(value: "The dequeued cell is not an instance of PreviewDataTableViewCell.")
            return UITableViewCell()
            
        }
        print(cell)
        cell.cityLabel.text = "London"
        cell.cityLetterLabel.text = "L"
        
        return  cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    

    
    func setupView() {
        

        if !UIAccessibilityIsReduceTransparencyEnabled() {

                let blurEffect = UIBlurEffect(style: .regular)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.translatesAutoresizingMaskIntoConstraints = false
                blurEffectView.frame = self.view.bounds
                self.view.addSubview(blurEffectView)
                blurEffectView.isHidden = false
            view.addSubview(blurEffectView.contentView)
         

            
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(searchBar)
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -230).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(searchTableView)
        searchTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchTableView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 8).isActive = true
        searchTableView.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -8).isActive = true
        
    }
    
    
    @objc func cancelButtonPressed(){
        print("CancelTapped")
        searchViewModel.cancelSearchView()
    }
}
