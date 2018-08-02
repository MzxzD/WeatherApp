import Foundation
import UIKit
import RxSwift
import RealmSwift

class HomeViewModel {
    
    var weatherInformation: Weather!
    var cityName: String? = ""
    var dataIsReady = PublishSubject<Bool>()
    var loaderControll = PublishSubject<Bool>()
    var errorOccured = PublishSubject<Bool>()
    var darkSkyDownloadTrigger = PublishSubject<Bool>()
    var darkServise = DarkSkyService()
    var searchCoordinatorDelegate: SearchViewDelegate?
    var settingsCoordinatorDelegate: SettingsViewDelegate?
    var cityLocation: CityCoordinates?
    var realmServise = RealmSerivce()
    var settingsConfiguration: Configuration!
    
    
    func initializeSettingsConfiguration() {
        
        if (realmServise.realm.objects(Configuration.self).isEmpty == true){
            settingsConfiguration = Configuration()
            if (!realmServise.create(object: settingsConfiguration)){
                errorOccured.onNext(true) }
        } else {
            if (settingsConfiguration == nil){
                settingsConfiguration = realmServise.getSettingsFromRealm()
            } else {
                if (  !realmServise.chechForUpdateSettings(unit: settingsConfiguration.unit, humidityBool: settingsConfiguration.humidityIsHidden, windBool: settingsConfiguration.windIsHidden, pressureBool: settingsConfiguration.pressureIsHidden) ) {
                    errorOccured.onNext(true)
                }
            }
            
        }
        
    }
    
    func initializeObservableDarkSkyService() -> Disposable{
        
        let darkSkyObservable = darkSkyDownloadTrigger.flatMap { (_) -> Observable<DataAndErrorWrapper<DarkSkyResponse>> in
                 self.weatherInformation = Weather()
            if ( self.realmServise.realm.objects(CityCoordinates.self).isEmpty == true) {
                let lat = "45.554962"
                let log = "18.695514"
                self.weatherInformation.cityName = "Osijek"
                return self.darkServise.fetchWetherDataFromDarkSky(lat: lat, log: log)
                
            } else {
                let cityToPassToDark = self.realmServise.realm.objects(CityCoordinates.self).last
                self.weatherInformation.cityName = cityToPassToDark?.cityname
                return self.darkServise.fetchWetherDataFromDarkSky(lat: (cityToPassToDark?.latitute)!, log: (cityToPassToDark?.longitude)!)
            }
        }
        
        
        return darkSkyObservable
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map({ [unowned self] (darkSkyData) -> DataAndErrorWrapper<DarkSkyResponse> in
               
                self.weatherInformation.humidity = (darkSkyData.data.currently.humidity) * 100
                self.weatherInformation.icon = icon(rawValue: (darkSkyData.data.currently.icon))
                self.weatherInformation.pressure = Int((darkSkyData.data.currently.pressure))
                self.weatherInformation.summary = (darkSkyData.data.currently.summary)
                self.weatherInformation.temperature = Int((darkSkyData.data.currently.temperature))
                self.weatherInformation.windSpeed = (darkSkyData.data.currently.windSpeed)
                
                
                let weatherImageTuple: (bodyWeatherImage: UIImage?,headerWeatherImaage: UIImage?,color: UIColor) =
                    self.getWeatherImageTuple()
                
            
                self.weatherInformation.bodyImage = weatherImageTuple.bodyWeatherImage
                self.weatherInformation.headerImage = weatherImageTuple.headerWeatherImaage
                self.weatherInformation.backgroundColor = weatherImageTuple.color
                let dailyArray = darkSkyData.data.daily.data
                var differenceInTime: Int!
                var smallestDifferenceInTime: Int!
                var temporaryClosestTime: Int!
                for dailyValues in dailyArray{
                    differenceInTime = abs((darkSkyData.data.currently.time) - dailyValues.time)
                    if (smallestDifferenceInTime != nil) {
                        if (differenceInTime < smallestDifferenceInTime){
                            smallestDifferenceInTime = differenceInTime
                            temporaryClosestTime = dailyValues.time
                        }
                    }else {
                        smallestDifferenceInTime = differenceInTime
                        temporaryClosestTime = dailyValues.time
                    }
                    
                }
                
                for dailyValues in dailyArray {
                    if (dailyValues.time == temporaryClosestTime){
                        
                        self.weatherInformation.temperatureMax = dailyValues.temperatureHigh
                        self.weatherInformation.temperatureMin = dailyValues.temperatureLow
                        self.weatherInformation.time = dailyValues.time
                        
                    }
                }
                self.weatherInformation = self.settingsConfiguration.values(weatherObject: self.weatherInformation)
                return (darkSkyData)
            })
            .subscribe(onNext: { (darkSkyData) in
                if darkSkyData.errorMessage == nil {
                    self.dataIsReady.onNext(true)
                    
                } else{
                    self.errorOccured.onNext(true)
                }
            })
    }
    
    func getWeatherImageTuple() -> (bodyWeatherImage: UIImage?,headerWeatherImaage: UIImage?,color: UIColor) {
        if (self.weatherInformation.icon == nil){
            self.weatherInformation.icon = icon(rawValue: "error")
            errorOccured.onNext(true)
        }
        return self.weatherInformation.icon.values()
    }
    
    func chechForNewWeatherInformation() {
        self.darkSkyDownloadTrigger.onNext(true)
        
    }
    
    func openSearchView() {
    
        self.searchCoordinatorDelegate?.openSearchView()
    }
    
    func openSettingsView(){
        self.settingsCoordinatorDelegate?.openSettingsView()
    }
    
}
