import Foundation
import UIKit
import RxSwift
import RealmSwift


class HomeViewModel {
    

//    fileprivate let geoNameService:GeoNamesService
//    fileprivate let darkSkyService:DarkSkyService
    
    var WeatherInformation = Weather()
    var successDownloadTime: Date?
    var coordinates: (laditude: String, longitude: String)?
    var cityName: String? = ""
    var dataIsReady = PublishSubject<Bool>()
    var loaderControll = PublishSubject<Bool>()
    var errorOccured = PublishSubject<Bool>()
    var geoDownloadTrigger = PublishSubject<Bool>()
    var darkSkyDownloadTrigger = PublishSubject<Bool>()
//    var realmServise = RealmSerivce()
    
    
    func initializeObservableGeoNames() -> Disposable{
        
        let geoObservable = geoDownloadTrigger.flatMap { [unowned self] (_) -> Observable<DataAndErrorWrapper<CityCoordinates>> in
            self.loaderControll.onNext(true)
            return GeoNamesService().fetchLatAndLogFromGeoNames()
        }
        
       return geoObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (geoData) in
                if geoData.errorMessage == nil{
                    print(self.WeatherInformation)
                    self.WeatherInformation.cityName = geoData.data.cityname
                    self.coordinates?.laditude = geoData.data.latitute!
                    self.coordinates?.longitude = geoData.data.longitude!
                    self.darkSkyDownloadTrigger.onNext(true)
                } else {
                    // ERROR OCCURED
                    self.errorOccured.onNext(true)
                }
            })
        
    }
    
    func initializeObservableDarkSkyService() -> Disposable{
        
        let darkSkyObservable = darkSkyDownloadTrigger.flatMap { (_) -> Observable<DataAndErrorWrapper<WeatherDataToViewModel>> in
            return DarkSkyService().fetchWetherDataFromDarkSky()
        }
        
        return darkSkyObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map({ (darkSkyData) -> DataAndErrorWrapper<WeatherDataToViewModel> in

                for dailyData in (darkSkyData.data.daily?.data)! {
                    if (dailyData.time == darkSkyData.data.currently?.time) {
                        self.WeatherInformation.temperatureMax = dailyData.temperatureHigh!
                        self.WeatherInformation.temperatureMin = dailyData.temperatureLow!
                    }
                }
                
                
                return (darkSkyData)
            })
            
            
            .subscribe(onNext: { (darkSkyData) in
                if darkSkyData.errorMessage == nil {
                    
                    self.WeatherInformation.humidity = (darkSkyData.data.currently?.humidity)!
                    self.WeatherInformation.icon = (darkSkyData.data.currently?.icon)!
                    self.WeatherInformation.pressure = (darkSkyData.data.currently?.pressure)!
                    self.WeatherInformation.summary = (darkSkyData.data.currently?.summary)!
                    self.WeatherInformation.temperature = (darkSkyData.data.currently?.temperature)!
                    self.WeatherInformation.windSpeed = (darkSkyData.data.currently?.windSpeed)!
                    
                    
                    
                    
                    
                    print(self.WeatherInformation)
                    self.dataIsReady.onNext(true)
                    
                    
                } else{
                    self.errorOccured.onNext(true)
                }
            })
        
        
    }
    func checkForNewData() {
        if (self.WeatherInformation.cityName == ""){
            self.darkSkyDownloadTrigger.onNext(true)
        }
    }
    
    
}
