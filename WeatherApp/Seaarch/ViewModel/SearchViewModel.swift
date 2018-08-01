//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift
import Realm

class SearchViewModel {
    
    var cityName: String? = ""
    var dataIsReady = PublishSubject<Bool>()
    var homeViewDataIsReady = PublishSubject<Bool>()
    var loaderControll = PublishSubject<Bool>()
    var errorOccured = PublishSubject<Bool>()
    var geoDownloadTrigger = PublishSubject<Bool>()
    var homeCoordinatorDelegate: SettingsViewDelegate?
    var cityCoordinates: [CityCoordinates] = []
    var querry: String!
    var searchCoordinatorDelegate: DissmissViewDelegate?
    var realmServise = RealmSerivce()
    
    init() {

    }
    
    init(dataIsReady: PublishSubject<Bool>) {
        self.dataIsReady = dataIsReady
    }
    
    
    
    func initializeObservableGeoNames() -> Disposable{
        
        let geoObservable = geoDownloadTrigger.flatMap { [unowned self] (_) -> Observable<DataAndErrorWrapper<[CityCoordinates]>> in
            self.loaderControll.onNext(true)
            self.querry = self.querry.replacingOccurrences(of: " ", with: "%20")
            return GeoNamesService().fetchLatAndLogFromGeoNames(querry: self.querry)
        }
        
        return geoObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (geoData) in
                if geoData.errorMessage == nil{
                    self.cityCoordinates = geoData.data
                    
                    self.dataIsReady.onNext(true)
                } else {
                    self.errorOccured.onNext(true)
                }
            })
    }
    
    func searchInitiated(querry: String) {
        self.querry = querry
        self.geoDownloadTrigger.onNext(true)
        
    }
    
    func cancelSearchView() {
        self.searchCoordinatorDelegate?.dissmissView()
    }
    
    func citySelected(selectedCity: Int) {
    
        let citySelectedData = CityCoordinates(value: self.cityCoordinates[selectedCity])
        
        let realmCityObject = realmServise.realm.objects(CityCoordinates.self).filter("cityname=%@", citySelectedData.cityname!)
        for element in realmCityObject {
            if ( element.cityname == citySelectedData.cityname) {
                if ( self.realmServise.delete(object: citySelectedData) ){}
                else {
                    errorOccured.onNext(true)
                }
            }
            
        }
        if ( !self.realmServise.create(object: citySelectedData) ){
            errorOccured.onNext(true)
        }
//        self.searchCoordinatorDelegate?.dissmissView()
        print(self.homeViewDataIsReady)
        self.homeViewDataIsReady = (self.searchCoordinatorDelegate?.startDownloadFromDarkSky())!
        print(self.homeViewDataIsReady)
        loaderControll.onNext(true)
        
    }
}

