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
    
    let cancelButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        let image = UIImage(named: "checkmark_uncheck") as UIImage?
        button.setBackgroundImage(image, for: .normal)
        button.titleLabel?.text = "X"
        button.titleLabel?.textColor = .black
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    var searchTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        view.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect )
        view.backgroundView = blurEffectView
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
        self.setupView()
        super.viewDidLoad()
        
    }
    
    let cellIdentifier = "WeatherViewCell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WeatherViewCell else
        {
            errorOccured(value: "The dequeued cell is not an instance of PreviewDataTableViewCell.")
            return UITableViewCell()
            
        }
        return  cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        listNewsViewModel.newsSelected(selectedNews: indexPath.row)
    }
    
    
    @objc func cancelButtonPressed(){
        print("CancelTapped")
    }
    
    func setupView() {
        
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(blurEffectView)
            
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.addSubview(searchTableView)
        searchTableView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 8).isActive = true
        searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
    }
    
    
}
