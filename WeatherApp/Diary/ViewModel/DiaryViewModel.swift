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
    var symptomDelegate: SymptomCoordinatorDelegate?
    var dissmissDelegate: DiaryCoordinator?
    var realmServise = RealmSerivce()
    var realmTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
    var dataIsReady = PublishSubject<Bool>()
    var averageSymptomValue = Symptoms()

    
    
    func getStoredSymptoms() -> Disposable {
        let realmObaerverTrigger = realmTrigger
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.symptomsArray.removeAll()
                    let realmSymptoms = self.realmServise.realm.objects(Symptoms.self)
                    for element in realmSymptoms {
                        self.symptomsArray.append(element)
                        
                    }
//                    self.dataIsReady.onNext(true)
                   self.averageSymptomValue = self.getAverageValues()
                }
            })
        return realmObaerverTrigger
    }
    
    
    func getAverageValues() -> Symptoms{
        let symptom = Symptoms()
        var summaries = Set<String>()
        let numberOfElements = self.symptomsArray.count
        for data in self.symptomsArray {
            symptom.headache += data.headache
            symptom.noWill += data.noWill
            symptom.rheumatism += data.rheumatism
            symptom.tiredness += data.tiredness
            symptom.weather?.humidity += (data.weather?.humidity)!
            symptom.weather?.pressure += (data.weather?.pressure)!
            symptom.weather?.temperatureMax += (data.weather?.temperatureMax)!
            symptom.weather?.temperatureMin += (data.weather?.temperatureMin)!
            symptom.weather?.windSpeed += (data.weather?.windSpeed)!
            summaries.insert((symptom.weather?.summary)!)
            symptom.weather?.temperature += (data.weather?.temperature)!
        }
        symptom.headache = symptom.headache / numberOfElements
        symptom.noWill = symptom.noWill / numberOfElements
        symptom.rheumatism = symptom.rheumatism / numberOfElements
        symptom.tiredness = symptom.tiredness / numberOfElements
        symptom.weather?.humidity = (symptom.weather?.humidity)! / Double(numberOfElements)
        symptom.weather?.pressure = (symptom.weather?.pressure)! / numberOfElements
        symptom.weather?.temperatureMax = (symptom.weather?.temperatureMax)! / Double(numberOfElements)
        symptom.weather?.temperatureMin = (symptom.weather?.temperatureMin)! / Double(numberOfElements)
        symptom.weather?.windSpeed = (symptom.weather?.windSpeed)! / Double(numberOfElements)
        symptom.weather?.temperature = (symptom.weather?.temperature)! / numberOfElements
        
        return symptom
    }
    
    func openSymptoms() {
        self.symptomDelegate?.openSymptomView()
    }
    
}
