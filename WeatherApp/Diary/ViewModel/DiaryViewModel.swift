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

class DiaryViewModel {
    var symptomsArray: [Symptoms] = []
    var weatherSymptoms: [Weather] = []
    var symptomDelegate: SymptomCoordinatorDelegate?
    var dissmissDelegate: DiaryCoordinator?
    var realmServise = RealmSerivce()
    var realmTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
    var dataIsReady = PublishSubject<Bool>()
    var averageSymptomValue = (Symptoms(), Weather())

    
    
    func getStoredSymptoms() -> Disposable {
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
//                    self.dataIsReady.onNext(true)
                   self.averageSymptomValue = self.getAverageValues()
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
    
    func openSymptoms() {
        self.symptomDelegate?.openSymptomView()
    }
    
}
