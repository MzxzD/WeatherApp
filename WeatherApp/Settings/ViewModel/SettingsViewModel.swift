//
//  SettingsViewModel.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift


class SettingsViewModel {
    
    var Cities: [CityCoordinates] = []
    var realmServise = RealmSerivce()
    var dataIsReady = PublishSubject<Bool>()
    var realmTrigger = PublishSubject<Bool>()
    var errorOccurd = PublishSubject<Bool>()
    var settingsCoordinatorDelegate: DissmissViewDelegate?
    var settingsConfiguration: Configuration!
    func initializeSettingsConfiguration() {
        settingsConfiguration = realmServise.getSettingsFromRealm()
    }
    
    func getStoredCities() -> Disposable {
        let realmObaerverTrigger = realmTrigger
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.Cities.removeAll()
                    let realmCities = self.realmServise.realm.objects(CityCoordinates.self)
                    for element in realmCities {
                        self.Cities.append(element)
                        
                    }
                    self.dataIsReady.onNext(true)
                }
            })
        return realmObaerverTrigger
    }
    
    func toggleMetric() -> Bool {
        if (realmServise.chechForUpdateSettings(unit: !settingsConfiguration.unit, humidityBool: settingsConfiguration.humidityIsHidden, windBool: settingsConfiguration.windIsHidden, pressureBool: settingsConfiguration.pressureIsHidden)){
        }
        else
        {
            errorOccurd.onNext(true)
        }
        return !settingsConfiguration.unit
    }
    
    func toggleImperial() -> Bool{
        if (realmServise.chechForUpdateSettings(unit: !settingsConfiguration.unit, humidityBool: settingsConfiguration.humidityIsHidden, windBool: settingsConfiguration.windIsHidden, pressureBool: settingsConfiguration.pressureIsHidden)){
        }
        else
        {
            errorOccurd.onNext(true)
        }
        return !settingsConfiguration.unit
    }
    
    func toggleWind() -> Bool {
        if (realmServise.chechForUpdateSettings(unit: settingsConfiguration.unit, humidityBool: settingsConfiguration.humidityIsHidden, windBool: !settingsConfiguration.windIsHidden, pressureBool: settingsConfiguration.pressureIsHidden)){
        }
        else
        {
            errorOccurd.onNext(true)
        }
        return !settingsConfiguration.windIsHidden
    }
    
    func togglePressure() -> Bool {
        if (realmServise.chechForUpdateSettings(unit: settingsConfiguration.unit, humidityBool: settingsConfiguration.humidityIsHidden, windBool: settingsConfiguration.windIsHidden, pressureBool: !settingsConfiguration.pressureIsHidden)){
        }
        else
        {
            errorOccurd.onNext(true)
        }
        return !settingsConfiguration.pressureIsHidden
    }
    
    func toggleHumidity() -> Bool {
        if (realmServise.chechForUpdateSettings(unit: settingsConfiguration.unit, humidityBool: !settingsConfiguration.humidityIsHidden, windBool: settingsConfiguration.windIsHidden, pressureBool: settingsConfiguration.pressureIsHidden)){
        }
        else
        {
            errorOccurd.onNext(true)
        }
        return !settingsConfiguration.humidityIsHidden
    }
    
    
    func dissmissTheView() {
        self.settingsCoordinatorDelegate?.dissmissView()
    }
    
    func deleteACity(selectedCity: Int) {
        let cityToRemove = Cities[selectedCity]
        if ( self.realmServise.delete(object: cityToRemove)) {
            self.Cities.remove(at: selectedCity)
            self.dataIsReady.onNext(true)
        } else {
            errorOccurd.onNext(true)
        }
    }
    
    func citySelected(selectedCty: Int){
        let citySelected = CityCoordinates(value: Cities[selectedCty])
        if (self.realmServise.delete(object: Cities[selectedCty])){} else { errorOccurd.onNext(true) }
        if (self.realmServise.create(object: citySelected)){} else {errorOccurd.onNext(true) }
        self.dissmissTheView()
    }
    
    
}
