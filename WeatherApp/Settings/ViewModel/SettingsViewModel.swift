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
import CoreLocation


class SettingsViewModel {
    let weather: Weather
    var localCoordinates: (latitude: Double, longitude: Double)?
    var cities: [CityCoordinates] = []
    var realmServise = RealmSerivce()
    var dataIsReady = PublishSubject<Bool>()
    var realmTrigger = PublishSubject<Bool>()
    var errorOccurd = PublishSubject<Bool>()
    var settingsCoordinatorDelegate: DissmissViewDelegate?
    var diaryDelegate: DiaryCoordinatorDelegate?
    var settingsConfiguration: Configuration!
    func initializeSettingsConfiguration() {
        settingsConfiguration = realmServise.getSettingsFromRealm()
    }

    
    init(weather: Weather) {
        self.weather = weather
    }
    
    func getStoredCities() -> Disposable {
        let realmObaerverTrigger = realmTrigger
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.cities.removeAll()
                    let realmCities = self.realmServise.realm.objects(CityCoordinates.self)
                    for element in realmCities {
                        self.cities.append(element)
                        
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
    
    func openDiary() {
        self.diaryDelegate?.openDiaryView()
    }
    
    func deleteACity(selectedCity: Int) {
        let cityToRemove = cities[selectedCity]
        if ( self.realmServise.delete(object: cityToRemove)) {
            self.cities.remove(at: selectedCity)
            self.dataIsReady.onNext(true)
        } else {
            errorOccurd.onNext(true)
        }
    }
    
    func citySelected(selectedCty: Int){
        let citySelected = CityCoordinates(value: cities[selectedCty])
        if citySelected.cityname == "Local"{
            if let latitude = self.localCoordinates?.latitude {
                citySelected.latitute = String(format:"%f",(latitude))
            }else {
                citySelected.latitute = "0"
            }
            if let longitude = self.localCoordinates?.longitude{
                citySelected.longitude = String(format:"%f",(longitude))
            }else {
                citySelected.longitude = "0"
            }
            
        }
        
        if (self.realmServise.delete(object: cities[selectedCty])){} else { errorOccurd.onNext(true) }
        if (self.realmServise.create(object: citySelected)){} else {errorOccurd.onNext(true) }
        self.dissmissTheView()
    }
    
    
}
