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

class SearchViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let disposeBag = DisposeBag()
    var searchViewModel: SearchViewModel!
    var alert = UIAlertController()
     let cellIdentifier = "WeatherViewCell"
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_uncheck"), for: .normal)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.clear, for: .normal)
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
        view.separatorColor = .clear
        view.separatorStyle = .none
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
        initializeDataObservable()
        view.backgroundColor = .gray
        self.setupView()
        searchViewModel.initializeObservableGeoNames().disposed(by: disposeBag)
        searchTableView.register(CityViewCell.self, forCellReuseIdentifier: cellIdentifier)
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
    }
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cityCoordinates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityViewCell else
        {
            errorOccured(value: "The dequeued cell is not an instance of PreviewDataTableViewCell.")
            return UITableViewCell()
            
        }
        let cityData = searchViewModel.cityCoordinates[indexPath.row]
        print(cell)
        cell.cityLabel.text = cityData.cityname
        cell.cityLetterLabel.text = String(describing: cityData.cityname!.first!)
        
        return  cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchViewModel.citySelected(selectedCity: indexPath.row)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if (searchBar.text == ""){
//            // ERROR!
//        }
        searchViewModel.querry = searchBar.text
        searchViewModel.geoDownloadTrigger.onNext(true)
    }
    
    func initializeDataObservable(){
        print("DataIsReadyObserver")
        let observer = searchViewModel.dataIsReady
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if event {
                    self.loadingIndicator.stopAnimating()
                    self.searchTableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func innitializeLoaderObservable() {
        let loadingObserver = searchViewModel.loaderControll
        loadingObserver.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if (event) {
                    self.loadingIndicator.rightAnchor.constraint(equalTo: self.cancelButton.leftAnchor, constant: 8).isActive = true
                    self.loadingIndicator.color = UIColor.white
                    self.view.addSubview(self.loadingIndicator)
                    self.loadingIndicator.startAnimating()
                } else{
                    self.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func initializeError() {
        let errorObserver = searchViewModel.errorOccured
        errorObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                if event {
                    self.loadingIndicator.stopAnimating()
                    downloadError(viewToPresent: self)
                } else {
                }
            })
            .disposed(by: disposeBag)
    }
    
}
