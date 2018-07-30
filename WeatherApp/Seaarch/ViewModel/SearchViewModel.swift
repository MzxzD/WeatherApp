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
    
    
//    var WeatherInformation = Weather()
    var cityName: String? = ""
    var dataIsReady = PublishSubject<Bool>()
    var loaderControll = PublishSubject<Bool>()
    var errorOccured = PublishSubject<Bool>()
    var geoDownloadTrigger = PublishSubject<Bool>()
    var darkSkyDownloadTrigger = PublishSubject<Bool>()
    var darkServise = GeoNamesService()
    var homeCoordinatorDelegate: SettingsViewDelegate?
    var cityCoordinates: [CityCoordinates] = []
    var querry: String!
    var searchCoordinatorDelegate: DissmissViewDelegate?
    var homeViewModel = HomeViewModel()
    var realmServise = RealmSerivce()
    
    func initializeObservableGeoNames() -> Disposable{

        let geoObservable = geoDownloadTrigger.flatMap { [unowned self] (_) -> Observable<DataAndErrorWrapper<[CityCoordinates]>> in
            self.loaderControll.onNext(true)
            return GeoNamesService().fetchLatAndLogFromGeoNames(querry: self.querry)
        }
        
        return geoObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (geoData) in
                print(geoData)
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
        print("chech")
        self.geoDownloadTrigger.onNext(true)
        
    }
    
    func cancelSearchView() {
        print("canceling....")
        self.searchCoordinatorDelegate?.dissmissView()
    }
    
    
    func citySelected(selectedCity: Int) {

        let citySelectedData = CityCoordinates(value: self.cityCoordinates[selectedCity])
        if (realmServise.realm.objects(CityCoordinates.self).filter("cityname=%@", citySelectedData.cityname!) == citySelectedData ) {
            if ( self.realmServise.delete(object: citySelectedData) ){}
            else {
                errorOccured.onNext(true)
            }
        } else {
            if ( self.realmServise.create(object: citySelectedData) ) {}
            else {
                errorOccured.onNext(true)
            }
        }
            self.searchCoordinatorDelegate?.dissmissView()
    }

    
}
