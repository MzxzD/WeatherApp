//
//  RealmService.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 30/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

class RealmSerivce {
    var realm = try! Realm()
    let errorOccured = PublishSubject<Bool>()
    
    func create<T: Object >(object: T) -> Bool {
        do{
            try realm.write {
                realm.add(object)
            }
        }catch {
            return false
        }
        return true
    }
    
    func delete<T: CityCoordinates>(object: T) -> Bool{
        do {
            try realm.write {
                realm.delete(realm.objects(CityCoordinates.self).filter("cityname=%@", object.cityname!))
            }
            
        } catch {
            return false
        }
        return true
    }
    
    func getCityLocations() -> (Observable<DataAndErrorWrapper<[CityCoordinates]>>){
        var cities: [CityCoordinates] = []
        let realmCities = self.realm.objects(CityCoordinates.self)
        for element in realmCities {
            cities += [element]
        }
        return Observable.just(DataAndErrorWrapper(data: cities, errorMessage: nil))
    }
    
    
    // ADD FUNCTION FOR SETTINGS OBJECT THAT UPDATES AND CREATES
    
    func chechForUpdateSettings(unit: UnitSystem, humidityBool: Bool, windBool: Bool, pressureBool: Bool) ->Bool{
        do{
            let realmSettings = self.realm.objects(SettingsConfiguration.self).first
            try realm.write {
                if (realmSettings?.unit != unit){
                    realmSettings?.unit = unit
                }
                if (realmSettings?.humidityIsShown != humidityBool){
                    realmSettings?.humidityIsShown = humidityBool
                }
                if (realmSettings?.windIsShown != windBool){
                    realmSettings?.windIsShown = windBool
                }
                if (realmSettings?.pressureIsShown != pressureBool){
                    realmSettings?.pressureIsShown = pressureBool
                }
            }
        }catch {
            return false
        }
        
        return true
    }
    
    func getSettingsFromRealm() -> SettingsConfiguration{
        let settings = self.realm.objects(SettingsConfiguration.self).first
        return settings!
        
    }
    
}
