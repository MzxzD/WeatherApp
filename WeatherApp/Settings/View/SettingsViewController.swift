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

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let disposeBag = DisposeBag()
    var settingsViewModel: SettingsViewModel!
    var alert = UIAlertController()
    let cellIdentifier = "WeatherViewCell"
    
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_uncheck"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var cityTableView: UITableView = {
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
    
    
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.textAlignment = .center
        label.text = "Location"
        label.textColor = UIColor.white
        return label
    }()
    
    
    var unitsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.textAlignment = .center
        label.text = "Units"
        label.textColor = UIColor.white
        return label
    }()
    
    var metricButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "square_checkmark_uncheck"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "square_checkmark_check"), for: .selected)
        button.addTarget(self, action: #selector(toggleMetric), for: .touchUpInside)
        return button  
    }()
    
    
    var metricLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.textAlignment = .center
        label.text = "Metric"
        label.textColor = UIColor.white
        return label
    }()
    
    var imperialButon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "square_checkmark_uncheck"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "square_checkmark_check"), for: .selected)
        button.setTitleColor(.clear, for: .normal)
        button.addTarget(self, action: #selector(toggleImeprial), for: .touchUpInside)
        return button
        
    }()
    
    
    var imperialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.textAlignment = .center
        label.text = "Imperial"
        label.textColor = UIColor.white
        return label
    }()
    
    var conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.textAlignment = .center
        label.text = "Conditions"
        label.textColor = UIColor.white
        return label
    }()
    
    
    var rainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "humidity_icon")
        return imageView
    }()
    
    var rainButon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_uncheck"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_check"), for: .selected)
        button.setTitleColor(.clear, for: .normal)
        button.addTarget(self, action: #selector(toggleHumidity), for: .touchUpInside)
        return button
        
    }()
    
    var windImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "wind_icon")
        return imageView
    }()
    
    var windButon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_uncheck"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_check"), for: .selected)
        button.setTitleColor(.clear, for: .normal)
        button.addTarget(self, action: #selector(toggleWind), for: .touchUpInside)
        return button
        
    }()
    
    var pressureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "pressure_icon")
        return imageView
    }()
    
    var pressureButon: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_uncheck"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_check"), for: .selected)
        button.setTitleColor(.clear, for: .normal)
        button.addTarget(self, action: #selector(togglePressure), for: .touchUpInside)
        return button
        
    }()
    
    var stackViewRainWindPressureImages: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    
    var stackViewRainWindPressureButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsViewModel.initializeSettingsConfiguration()
        addBlurEffectToBackground()
        cityTableView.register(CityViewCell.self, forCellReuseIdentifier: cellIdentifier)
        cityTableView.dataSource = self
        cityTableView.delegate = self
        settingsViewModel.getStoredCities().disposed(by: disposeBag)
        setupView()
        initializeRealmObservable()
        initializeError()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        startGettingDataFromRealm()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParentViewController {
            settingsViewModel.settingsCoordinatorDelegate?.viewHasFinished()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewModel.cities.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityViewCell else
        {
            errorOccured(viewToPresent: self)
            return UITableViewCell()
            
        }
        let cityData = settingsViewModel.cities[indexPath.row]
        cell.cityLabel.text = cityData.cityname
        print(cityData)
        cell.cityLetterLabel.text = String(describing: cityData.cityname!.first!)
        
        return  cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingsViewModel.citySelected(selectedCty: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.settingsViewModel.deleteACity(selectedCity: indexPath.row)
        }
    }
    
    func addBlurEffectToBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    
    func setupView(){
        
        view.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(cityTableView)
        cityTableView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        cityTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        cityTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        cityTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(unitsLabel)
        unitsLabel.topAnchor.constraint(equalTo: cityTableView.bottomAnchor, constant: 10).isActive = true
        unitsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        unitsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(metricButton)
        metricButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        metricButton.topAnchor.constraint(equalTo: unitsLabel.bottomAnchor, constant: 10).isActive = true
        metricButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        metricButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(metricLabel)
        metricLabel.leadingAnchor.constraint(equalTo: metricButton.trailingAnchor, constant: 8).isActive = true
        metricLabel.topAnchor.constraint(equalTo: unitsLabel.bottomAnchor, constant: 10).isActive = true
        metricLabel.centerYAnchor.constraint(equalTo: metricButton.centerYAnchor).isActive = true
        
        view.addSubview(imperialButon)
        imperialButon.topAnchor.constraint(equalTo: metricButton.bottomAnchor, constant: 4).isActive = true
        imperialButon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        imperialButon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imperialButon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(imperialLabel)
        imperialLabel.leadingAnchor.constraint(equalTo: imperialButon.trailingAnchor, constant: 8).isActive = true
        imperialLabel.topAnchor.constraint(equalTo: metricButton.bottomAnchor).isActive = true
        imperialLabel.centerYAnchor.constraint(equalTo: imperialButon.centerYAnchor).isActive = true
        
        view.addSubview(conditionLabel)
        conditionLabel.topAnchor.constraint(equalTo: imperialButon.bottomAnchor, constant: 10).isActive = true
        conditionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        conditionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(stackViewRainWindPressureImages)
        stackViewRainWindPressureImages.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackViewRainWindPressureImages.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackViewRainWindPressureImages.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 10).isActive = true
        stackViewRainWindPressureImages.heightAnchor.constraint(equalToConstant: 70).isActive = true
        stackViewRainWindPressureImages.addArrangedSubview(rainImageView)
        stackViewRainWindPressureImages.addArrangedSubview(windImageView)
        stackViewRainWindPressureImages.addArrangedSubview(pressureImageView)
        
        view.addSubview(rainButon)
        rainButon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        rainButon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        rainButon.topAnchor.constraint(equalTo: rainImageView.bottomAnchor, constant: 4).isActive = true
        rainButon.centerXAnchor.constraint(equalTo: rainImageView.centerXAnchor).isActive = true
        
        view.addSubview(windButon)
        windButon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        windButon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        windButon.topAnchor.constraint(equalTo: windImageView.bottomAnchor, constant: 4).isActive = true
        windButon.centerXAnchor.constraint(equalTo: windImageView.centerXAnchor).isActive = true
        
        view.addSubview(pressureButon)
        pressureButon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        pressureButon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pressureButon.topAnchor.constraint(equalTo: pressureImageView.bottomAnchor, constant: 4).isActive = true
        pressureButon.centerXAnchor.constraint(equalTo: pressureImageView.centerXAnchor).isActive = true
        
        view.addSubview(doneButton)
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        
        rainButon.isSelected = !settingsViewModel.settingsConfiguration.humidityIsHidden
        pressureButon.isSelected = !settingsViewModel.settingsConfiguration.pressureIsHidden
        windButon.isSelected = !settingsViewModel.settingsConfiguration.windIsHidden
        
        imperialButon.isSelected = settingsViewModel.settingsConfiguration.unit
        metricButton.isSelected = !settingsViewModel.settingsConfiguration.unit
        
        
    }
    
    
    func initializeRealmObservable() {
        let observer = settingsViewModel.dataIsReady
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.cityTableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
    
    func startGettingDataFromRealm() {
        settingsViewModel.realmTrigger.onNext(true)
    }
    
    
    func initializeError() {
        let errorObserver = self.settingsViewModel.errorOccurd
        errorObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                if event {
                    errorOccured(viewToPresent: self)
                } else {
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    @objc func toggleMetric(){
        metricButton.isSelected = settingsViewModel.toggleMetric()
        imperialButon.isSelected = !metricButton.isSelected
        self.setupView()
    }
    
    @objc func toggleImeprial(){
        imperialButon.isSelected = settingsViewModel.toggleImperial()
        metricButton.isSelected = !imperialButon.isSelected
        self.setupView()
    }
    
    @objc func toggleWind(){
        windButon.isSelected = !settingsViewModel.toggleWind()
        self.setupView()
    }
    
    @objc func togglePressure(){
        pressureButon.isSelected = !settingsViewModel.togglePressure()
        self.setupView()
    }
    
    @objc func toggleHumidity(){
        rainButon.isSelected = !settingsViewModel.toggleHumidity()
        self.setupView()
    }
    
    @objc func doneButtonPressed() {
        self.settingsViewModel.dissmissTheView()
    }
    
}
