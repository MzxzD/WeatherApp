//
//  DiaryViewModel.swift
//  WeatherApp
//
//  Created by Mateo Doslic on 16/09/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift

enum GraphEnum{
    case headache
    case tiredness
    case rheumatism
    case noWill
    case humidity
    case pressure
    case temperatureMax
    case temperatureMin
    case windSpeed
    case temperature
}
typealias GraphNames = (type:GraphEnum, name:String)
typealias ItemsGraphArray = Array<GraphNames>

class DiaryViewModel: DiaryViewModelProtocol {
    var loaderPublisher: PublishSubject<Bool>
    var itemsToPresent: [TableSectionItem<TableTypes, TableTypes, GraphNames>] = []
    var refreshView: PublishSubject<TableRefresh>
    var symptomsArray: [Symptoms] = []
    var weatherSymptoms: [Weather] = []
    var symptomDelegate: SymptomCoordinatorDelegate?
    var dissmissDelegate: DiaryCoordinator?
    var realmServise = RealmSerivce()
    var realmTrigger : ReplaySubject<Bool>
    var dataIsReady : PublishSubject<Bool>
    var averageSymptomValue = (Symptoms(), Weather())
    let itemsNameArray : ItemsGraphArray = [(type: .headache , name: "Headache scale :"), (type: .tiredness , name: "Tiredness scale :"), (type: .rheumatism , name: "Rheumatism scale :"), (type: .noWill , name: "No Will scale :"), (type: .humidity , name: "Humidity scale :"), (type: .pressure , name: "Pressure scale :"), (type: .temperatureMax , name: "MaxTemperature scale :"), (type: .temperatureMin , name: "MinTemperature scale :"), (type: .windSpeed , name: "Speed of wind scale :"), (type: .temperature , name: "Temperature scale :")    ]
    
    
    
    init() {
        self.realmTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        self.dataIsReady = PublishSubject<Bool>()
        self.refreshView = PublishSubject<TableRefresh>()
        self.loaderPublisher = PublishSubject<Bool>()
    }
    
    func getStoredSymptoms() -> Disposable {
        self.loaderPublisher.onNext(true)
        let realmObaerverTrigger = realmTrigger
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.symptomsArray.removeAll()
                    let realmSymptoms = self.realmServise.realm.objects(Symptoms.self)
                    let weatherData = self.realmServise.realm.objects(Weather.self)
                    for element in realmSymptoms {
                        self.symptomsArray.append(element)
                        
                    }
                    for element in weatherData{
                        self.weatherSymptoms.append(element)
                    }

                    self.averageSymptomValue = self.getAverageValues()
                    self.itemsToPresent = self.getDataForGraphs()
                    self.loaderPublisher.onNext(false)
                    self.refreshView.onNext(.complete)
                }
            })
        return realmObaerverTrigger
    }
    
    
    func getAverageValues() -> (Symptoms, Weather){
        let symptom = Symptoms()
        let weather = Weather()
        var summaries = Set<String>()
        let numberOfSymptomElements = self.symptomsArray.count
        let numberOfWeatherElements = self.weatherSymptoms.count
        for data in self.symptomsArray {
            symptom.headache += data.headache
            symptom.noWill += data.noWill
            symptom.rheumatism += data.rheumatism
            symptom.tiredness += data.tiredness

        }
        
        for data in self.weatherSymptoms{
            weather.humidity += (data.humidity)
            weather.pressure += (data.pressure)
            weather.temperatureMax += (data.temperatureMax)
            weather.temperatureMin += (data.temperatureMin)
            weather.windSpeed += (data.windSpeed)
            summaries.insert(data.summary)
            weather.temperature += (data.temperature)
        }
        symptom.headache = symptom.headache / numberOfSymptomElements
        symptom.noWill = symptom.noWill / numberOfSymptomElements
        symptom.rheumatism = symptom.rheumatism / numberOfSymptomElements
        symptom.tiredness = symptom.tiredness / numberOfSymptomElements
        weather.humidity = (weather.humidity) / Double(numberOfWeatherElements)
        weather.pressure = (weather.pressure) / numberOfWeatherElements
        weather.temperatureMax = (weather.temperatureMax) / Double(numberOfWeatherElements)
        weather.temperatureMin = (weather.temperatureMin) / Double(numberOfWeatherElements)
        weather.windSpeed = (weather.windSpeed) / Double(numberOfWeatherElements)
        weather.temperature = (weather.temperature) / numberOfWeatherElements
        
        return (symptom, weather)
    }
    
    
    func getDataForGraphs() -> [TableSectionItem<TableTypes, TableTypes, GraphNames>] {
        var data: [TableSectionItem<TableTypes, TableTypes, GraphNames>] = []
        for element in self.itemsNameArray{
            let tableItem: [TableItem<TableTypes, GraphNames>] = [TableItem(type: TableTypes.general, data: element)]
            data += [TableSectionItem(type: TableTypes.general, sectionTitle: .empty, footerTitle: .empty, items: tableItem)]
        }
        
        return data
    }
    
    
    func openSymptoms() {
        self.symptomDelegate?.openSymptomView()
    }
    
    func start() {
        self.realmTrigger.onNext(true)
    }
    
}


protocol DiaryViewModelProtocol: TableRefreshViewModelProtocol,LoaderViewModelProtocol {
    var itemsToPresent: [TableSectionItem<TableTypes, TableTypes, GraphNames>] {get}
    var symptomDelegate: SymptomCoordinatorDelegate? {get set}
    var dissmissDelegate: DiaryCoordinator? {get set}
    var symptomsArray: [Symptoms] {get}
    var weatherSymptoms: [Weather] {get}
    func openSymptoms()
    var dataIsReady: PublishSubject<Bool> {get}
    func getStoredSymptoms() -> Disposable
    func start()

}
