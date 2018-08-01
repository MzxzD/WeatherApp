import Foundation
import UIKit
import RxSwift
import RealmSwift


class HomeViewModel {
    
    var WeatherInformation = Weather()
    var cityName: String? = ""
    var dataIsReady = PublishSubject<Bool>()
    var loaderControll = PublishSubject<Bool>()
    var errorOccured = PublishSubject<Bool>()
    var geoDownloadTrigger = PublishSubject<Bool>()
    var darkSkyDownloadTrigger = PublishSubject<Bool>()
    var darkServise = DarkSkyService()
    var searchCoordinatorDelegate: SearchViewDelegate?
    var settingsCoordinatorDelegate: SettingsViewDelegate?
    var cityCoordinates: CityCoordinates!
    //    var realmServise = RealmSerivce()
    
    
    func initializeObservableGeoNames() -> Disposable{
        
        let geoObservable = geoDownloadTrigger.flatMap { [unowned self] (_) -> Observable<DataAndErrorWrapper<[CityCoordinates]>> in
            self.loaderControll.onNext(true)
            return GeoNamesService().fetchLatAndLogFromGeoNames(querry: "Osijek")
        }
        
        return geoObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (geoData) in
                print(geoData)
                if geoData.errorMessage == nil{
                    self.cityCoordinates = geoData.data.first
                    
                    self.dataIsReady.onNext(true)
                } else {
                    self.errorOccured.onNext(true)
                }
            })
    }
    
    func initializeObservableDarkSkyService() -> Disposable{
        
        let darkSkyObservable = darkSkyDownloadTrigger.flatMap { (_) -> Observable<DataAndErrorWrapper<DarkSkyResponse>> in

            print("triggered")
            return self.darkServise.fetchWetherDataFromDarkSky(lat: self.cityCoordinates.latitute! , log: self.cityCoordinates.longitude!)
        }
        
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
        if WeatherInformation.time != 0{
            return
        }
        self.geoDownloadTrigger.onNext(true)
        
    }
    
    func openSearchView() {
        print("funcInitiated")
        self.searchCoordinatorDelegate?.OpenSearchView()
    }
    
    func openSettingsView(){
        self.settingsCoordinatorDelegate?.OpenSettingsView()
    }
    
}
