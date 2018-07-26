import Foundation
import UIKit
import RxSwift
import RealmSwift


class HomeViewModel {
    
    var WeatherInformation = Weather()
    var successDownloadTime: Date?
    var coordinates: (laditude: String, longitude: String)?
    var cityName: String? = ""
    var dataIsReady = PublishSubject<Bool>()
    var loaderControll = PublishSubject<Bool>()
    var errorOccured = PublishSubject<Bool>()
    var geoDownloadTrigger = PublishSubject<Bool>()
    var darkSkyDownloadTrigger = PublishSubject<Bool>()
    var darkServise = DarkSkyService()
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
                    self.WeatherInformation.cityName = geoData.data.cityname
                    self.coordinates?.laditude = geoData.data.latitute!
                    self.coordinates?.longitude = geoData.data.longitude!
                    self.darkSkyDownloadTrigger.onNext(true)
                } else {
                    self.errorOccured.onNext(true)
                }
            })
        
    }
    
    func initializeObservableDarkSkyService() -> Disposable{
        let darkSkyObservable = self.darkServise.fetchWetherDataFromDarkSky()
//        let darkSkyObservable = darkSkyDownloadTrigger.flatMap { (_) -> Observable<DataAndErrorWrapper<DarkSkyResponse>> in
////             self.loaderControll.onNext(true)
//            print("triggered")
//            return self.darkServise.fetchWetherDataFromDarkSky()
//        }
        
        return darkSkyObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map({ [unowned self] (darkSkyData) -> DataAndErrorWrapper<DarkSkyResponse> in
                self.WeatherInformation.humidity = (darkSkyData.data.currently?.humidity)! * 100
                self.WeatherInformation.icon = icon(rawValue: (darkSkyData.data.currently?.icon)!)
                self.WeatherInformation.pressure = Int((darkSkyData.data.currently?.pressure)!)
                self.WeatherInformation.summary = (darkSkyData.data.currently?.summary)!
                self.WeatherInformation.temperature = Int((darkSkyData.data.currently?.temperature)!)
                self.WeatherInformation.windSpeed = (darkSkyData.data.currently?.windSpeed)!
                print("saving data")
                let weatherImageTuple: (bodyWeatherImage: UIImage,headerWeatherImaage: UIImage,color: UIColor) = (self.WeatherInformation.icon?.values())!
                self.WeatherInformation.bodyImage = weatherImageTuple.bodyWeatherImage
                self.WeatherInformation.headerImage = weatherImageTuple.headerWeatherImaage
                self.WeatherInformation.backgroundColor = weatherImageTuple.color
                
                let dailyArray = darkSkyData.data.daily?.data
                var differenceInTime: Int!
                var smallestDifferenceInTime: Int!
                var temporaryClosestTime: Int!
                for dailyValues in dailyArray!{
                    differenceInTime = abs((darkSkyData.data.currently?.time)! - dailyValues.time!)
                    if (smallestDifferenceInTime != nil) {
                        if (differenceInTime < smallestDifferenceInTime){
                            smallestDifferenceInTime = differenceInTime
                            temporaryClosestTime = dailyValues.time!
                        }
                    }else {
                        smallestDifferenceInTime = differenceInTime
                        temporaryClosestTime = dailyValues.time!
                    }
                    
                }
                
                for dailyValues in dailyArray! {
                    if (dailyValues.time == temporaryClosestTime){
                        
                        self.WeatherInformation.temperatureMax = dailyValues.temperatureHigh!
                        self.WeatherInformation.temperatureMin = dailyValues.temperatureLow!
                        self.WeatherInformation.time = dailyValues.time!
                        
                    }
                }
                
                return (darkSkyData)
            })
            .subscribe(onNext: { (darkSkyData) in
                if darkSkyData.errorMessage == nil {
                    print("huh")
                    self.dataIsReady.onNext(true)
                    
                } else{
                    self.errorOccured.onNext(true)
                }
            })
    }
    func chechForNewWeatherInformation() {
        print("chech")
        self.darkSkyDownloadTrigger.onNext(true)
        
    }
    
}
