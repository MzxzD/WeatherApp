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
    
    
    
    
    func dissmissTheView() {
        print("canceling....")
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
    self.realmServise.delete(object: Cities[selectedCty])
    self.realmServise.create(object: citySelected)
    self.dissmissTheView()
    }
    
    
}
