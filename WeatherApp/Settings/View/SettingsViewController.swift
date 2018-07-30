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
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.clear, for: .normal)
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var cityTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        view.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect )
        //        view.backgroundView = blurEffectView
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
//        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
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
        //        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
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
        //        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
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
        //        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
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
        //        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
        
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
//        stackView.alignment = .center
        return stackView
    }()
    
    var unitStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    var unitMetricStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution =
        stackView.axis = .horizontal
        stackView.alignment = .leading
        
        return stackView
    }()
    
    
    var unitImperialtackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //        stackView.distribution =
        stackView.axis = .horizontal
        stackView.alignment = .leading
        
        return stackView
    }()
    
    
    var conditionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    var conditionElementStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillProportionally
    stackView.axis = .vertical
    stackView.alignment = .center
    return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        cityTableView.register(CityViewCell.self, forCellReuseIdentifier: cellIdentifier)
        cityTableView.dataSource = self
        cityTableView.delegate = self
        settingsViewModel.getStoredCities().disposed(by: disposeBag)
        initializeRealmObservable()
        initializeError()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        return settingsViewModel.Cities.count
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityViewCell else
        {
            errorOccured(value: "The dequeued cell is not an instance of PreviewDataTableViewCell.")
            return UITableViewCell()

        }
        let cityData = settingsViewModel.Cities[indexPath.row]
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
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    
    func setupView(){
        
        
        view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(cityTableView)
        cityTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        cityTableView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8).isActive = true
        stackView.addArrangedSubview(unitsLabel)
        
        stackView.addArrangedSubview(unitStackView)
        unitStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        
        unitStackView.addArrangedSubview(unitMetricStackView)
        unitMetricStackView.leadingAnchor.constraint(equalTo: unitStackView.leadingAnchor).isActive = true
        unitMetricStackView.addArrangedSubview(metricButton)
        metricButton.leadingAnchor.constraint(equalTo: unitMetricStackView.leadingAnchor, constant: 8).isActive = true
        metricButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        metricButton.topAnchor.constraint(equalTo: unitMetricStackView.topAnchor, constant: 0).isActive = true
        
        unitMetricStackView.addArrangedSubview(metricLabel)
        metricLabel.leadingAnchor.constraint(equalTo: metricButton.trailingAnchor, constant: 8).isActive = true
        metricLabel.centerYAnchor.constraint(equalTo: metricButton.centerYAnchor, constant: 0).isActive = true
        
        unitStackView.addArrangedSubview(unitMetricStackView)
        unitMetricStackView.leadingAnchor.constraint(equalTo: unitStackView.leadingAnchor).isActive = true
        unitMetricStackView.addArrangedSubview(imperialButon)
        imperialButon.leadingAnchor.constraint(equalTo: unitMetricStackView.leadingAnchor, constant: 8).isActive = true
        imperialButon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imperialButon.topAnchor.constraint(equalTo: unitMetricStackView.topAnchor, constant: 0).isActive = true
        
        unitMetricStackView.addArrangedSubview(imperialLabel)
        imperialLabel.leadingAnchor.constraint(equalTo: imperialButon.trailingAnchor, constant: 8).isActive = true
        imperialLabel.centerYAnchor.constraint(equalTo: imperialButon.centerYAnchor, constant: 0).isActive = true
        

        
        
        
        
        
//        unitMetricStackView.addArrangedSubview(metricButton)
//        metricButton.leadingAnchor.constraint(equalTo: unitStackView.leadingAnchor, constant: 8).isActive = true
//        metricButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        unitMetricStackView.addArrangedSubview(metricLabel)
      

        
//
//        // dodati imperial
//
//        stackView.addArrangedSubview(conditionLabel)
//        stackView.addArrangedSubview(conditionsStackView)
//        conditionsStackView.addArrangedSubview(conditionElementStackView)
//        conditionElementStackView.addArrangedSubview(rainImageView)
//        conditionElementStackView.addArrangedSubview(rainButon)
//        conditionsStackView.addArrangedSubview(conditionElementStackView)
//        conditionElementStackView.addArrangedSubview(windImageView)
//        conditionElementStackView.addArrangedSubview(windButon)
    
        
    }
    
    
    func initializeRealmObservable() {
        let observer = settingsViewModel.dataIsReady
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.setupView()
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
                    errorOccured(value: "Failed to delete news or it was allrealy deleted!")
                } else {
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    
    
    
    
    
    
    

    @objc func doneButtonPressed() {
        self.settingsViewModel.dissmissTheView()
    }
    
}
