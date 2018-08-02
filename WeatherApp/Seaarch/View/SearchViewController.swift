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
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    var searchTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        view.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect )
        view.separatorColor = .clear
        view.separatorStyle = .none
        view.backgroundColor = .clear
        return view
    }()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = UIColor.white
        searchBar.layer.cornerRadius = 20
        searchBar.clipsToBounds = true
        let searchTextField = searchBar.value(forKey: "searchField") as! UITextField
        searchTextField.leftView = nil
        searchTextField.placeholder = "Search"
        searchTextField.rightView = UIImageView(image: UIImage(named: "search_icon"))
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        initializeDataObservable()
        innitializeLoaderObservable()
        addBlurEffectToBackground()
        self.setupView()
        searchViewModel.initializeObservableGeoNames().disposed(by: disposeBag)
        searchTableView.register(CityViewCell.self, forCellReuseIdentifier: cellIdentifier)
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
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
             errorOccured(viewToPresent: self)
            return UITableViewCell()
            
        }
        let cityData = searchViewModel.cityCoordinates[indexPath.row]
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
    
    
    func addBlurEffectToBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    func setupView() {        
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
        searchViewModel.querry = searchBar.text
        searchViewModel.geoDownloadTrigger.onNext(true)
    }
    
    func initializeDataObservable(){
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
                    self.loadingIndicator.center = self.view.center
                    self.loadingIndicator.color = UIColor.white
                    self.view.addSubview(self.loadingIndicator)
                    self.loadingIndicator.startAnimating()
                } else{
                    self.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        
        let homeViewDownloadloadingObserver = searchViewModel.homeViewDataIsReady
        homeViewDownloadloadingObserver.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if (event) {
                    print("WEEEE")
                     self.loadingIndicator.stopAnimating()
                    self.searchViewModel.cancelSearchView()
                } else{
                   print("loaderobservernada")
                    self.loadingIndicator.center = self.view.center
                    self.loadingIndicator.color = UIColor.white
                    self.view.addSubview(self.loadingIndicator)
                    self.loadingIndicator.startAnimating()
                    
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
                     errorOccured(viewToPresent: self)
                } else {
                }
            })
            .disposed(by: disposeBag)
    }
    
}
