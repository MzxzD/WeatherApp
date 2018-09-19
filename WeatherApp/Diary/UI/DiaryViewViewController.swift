//
//  DiaryViewViewController.swift
//  WeatherApp
//
//  Created by Mateo Doslic on 16/09/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit
import Charts
import RxSwift

class DiaryViewViewController: UIViewController, TableRefreshView,LoaderViewProtocol,UITableViewDelegate, UITableViewDataSource  {
    var disposeBag = DisposeBag()
    var VM: DiaryViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurEffectToBackground()
        setupConstraints()
        initializeRealmObservable()
        setupTableView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    var tableView: UITableView! = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
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
    
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "checkmark_uncheck"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()

    func initializeRealmObservable() {
        let observer = VM.dataIsReady
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
        initializeRefreshDriver(refreshObservable: VM.refreshView)
        initializeLoaderObserver(VM.loaderPublisher)
        VM.getStoredSymptoms().disposed(by: disposeBag)
    }
    
    func fetchData() {
        VM.start()
    }
    
    func addBlurEffectToBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    @objc func doneButtonPressed() {
        VM.dissmissDelegate?.dissmissView()
    }
    
    @objc func addButtonPressed() {
        VM.openSymptoms()
    }
    
    
    func setupView(){
//        view.addSubviews(addButton, doneButton, tableView)
        setupTableView()
        setupConstraints()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BarTableViewCell.self, forCellReuseIdentifier: BarTableViewCell.identifier)
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return VM.itemsToPresent.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.itemsToPresent[section].items.count
    }
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 300.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BarTableViewCell = tableView.dequeue(for: indexPath)
        let cellElement = VM.itemsToPresent[indexPath.section].items[indexPath.row]
        var dataEntries: [BarChartDataEntry] = []
        
        switch cellElement.data.type {
            
            
        case .headache:
            
            for element in VM.symptomsArray.enumerated() {
                let averageDataCollected = BarChartDataEntry(x:Double(element.offset+1) , y: Double(element.element.headache))
                dataEntries.append(averageDataCollected)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Headacke")
            chartDataSet.colors = [generateRandomColor()]
            let chartData = BarChartData(dataSet: chartDataSet)
            cell.chart.data = chartData
            
            
        case .tiredness:
            for element in VM.symptomsArray.enumerated() {
                let averageDataCollected = BarChartDataEntry(x:Double(element.offset+1) , y: Double(element.element.tiredness))
                dataEntries.append(averageDataCollected)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Tiredness")
            chartDataSet.colors = [generateRandomColor()]

            let chartData = BarChartData(dataSet: chartDataSet)
            cell.chart.data = chartData
            
        case .rheumatism:
            for element in VM.symptomsArray.enumerated() {
                let averageDataCollected = BarChartDataEntry(x:Double(element.offset+1) , y: Double(element.element.rheumatism))
                dataEntries.append(averageDataCollected)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Rheumatish")
              chartDataSet.colors = [generateRandomColor()]
            let chartData = BarChartData(dataSet: chartDataSet)
            cell.chart.data = chartData
            
        case .noWill:
            for element in VM.symptomsArray.enumerated() {
                let averageDataCollected = BarChartDataEntry(x:Double(element.offset+1) , y: Double(element.element.noWill))
                dataEntries.append(averageDataCollected)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "No will")
            chartDataSet.colors = [generateRandomColor()]
            let chartData = BarChartData(dataSet: chartDataSet)
            cell.chart.data = chartData
            
        case .humidity:
            for element in VM.weatherSymptoms.enumerated() {
                let averageDataCollected = BarChartDataEntry(x:Double(element.offset+1) , y: Double(element.element.humidity))
                dataEntries.append(averageDataCollected)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Humidity")
            chartDataSet.colors = [generateRandomColor()]
            let chartData = BarChartData(dataSet: chartDataSet)
            cell.chart.data = chartData
            
        case .pressure:
            for element in VM.weatherSymptoms.enumerated() {
                let averageDataCollected = BarChartDataEntry(x:Double(element.offset+1) , y: Double(element.element.pressure))
                dataEntries.append(averageDataCollected)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Pressure")
            chartDataSet.colors = [generateRandomColor()]

            let chartData = BarChartData(dataSet: chartDataSet)
            cell.chart.data = chartData
            
        case .temperatureMax:
            for element in VM.weatherSymptoms.enumerated() {
                let averageDataCollected = BarChartDataEntry(x:Double(element.offset+1) , y: Double(element.element.temperatureMax))
                dataEntries.append(averageDataCollected)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Max Temerature")
            chartDataSet.colors = [generateRandomColor()]

            let chartData = BarChartData(dataSet: chartDataSet)
            cell.chart.data = chartData
            
        case .temperatureMin:
            for element in VM.weatherSymptoms.enumerated() {
                let averageDataCollected = BarChartDataEntry(x:Double(element.offset+1) , y: Double(element.element.temperatureMin))
                dataEntries.append(averageDataCollected)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Min Temperature")
            chartDataSet.colors = [generateRandomColor()]

            let chartData = BarChartData(dataSet: chartDataSet)
            cell.chart.data = chartData
            
        case .windSpeed:
            for element in VM.weatherSymptoms.enumerated() {
                let averageDataCollected = BarChartDataEntry(x:Double(element.offset+1) , y: Double(element.element.windSpeed))
                dataEntries.append(averageDataCollected)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Speed Of Wind")
            chartDataSet.colors = [generateRandomColor()]

            let chartData = BarChartData(dataSet: chartDataSet)
            cell.chart.data = chartData
            
        case .temperature:
            for element in VM.weatherSymptoms.enumerated() {
                let averageDataCollected = BarChartDataEntry(x:Double(element.offset+1) , y: Double(element.element.temperature))
                dataEntries.append(averageDataCollected)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Temperature")
            chartDataSet.colors = [generateRandomColor()]

            let chartData = BarChartData(dataSet: chartDataSet)
            cell.chart.data = chartData
            
        }
        //        cell.chart.barData
        
        
        return cell
    }
    
    
    
    func setupConstraints() {
        view.addSubview(addButton)
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(doneButton)
        doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55).isActive = true
        
    }
    
}


func generateRandomColor() -> UIColor {
    let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
    let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
    let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
    
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
}

