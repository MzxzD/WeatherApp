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
    
    func create<T : CityCoordinates >(object: T) -> Bool {
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
                realm.delete(realm.objects(CityCoordinates.self).filter("title=%@", object.cityname!))
            }
            
        } catch {
            return false
        }
        return true
    }
    
    func getFavoriteData() -> (Observable<DataAndErrorWrapper<[CityCoordinates]>>){
        var cities: [CityCoordinates] = []
        let realmCities = self.realm.objects(CityCoordinates.self)
        for element in realmCities {
            cities += [element]
        }
        return Observable.just(DataAndErrorWrapper(data: cities, errorMessage: nil))
    }
    
    
    // ADD FUNCTION FOR SETTINGS OBJECT THAT UPDATES AND CREATES
    
}
