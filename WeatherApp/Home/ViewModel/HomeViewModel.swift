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
    var darkSkyDownloadTrigger = PublishSubject<Bool>()
    var darkServise = DarkSkyService()
    var searchCoordinatorDelegate: SearchViewDelegate?
    var settingsCoordinatorDelegate: SettingsViewDelegate?
    var cityLocation: CityCoordinates?
    var realmServise = RealmSerivce()
    var settingsConfiguration: Configuration!
    

    func initializeSettingsConfiguration() {

        if (realmServise.realm.objects(Configuration.self).isEmpty == true){
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
            
            if ( self.realmServise.realm.objects(CityCoordinates.self).isEmpty == true) {
                let lat = "45.554962"
                let log = "18.695514"
                self.WeatherInformation.cityName = "Osijek"
                     return self.darkServise.fetchWetherDataFromDarkSky(lat: lat, log: log)
                
            } else {
                let cityToPassToDark = self.realmServise.realm.objects(CityCoordinates.self).last
                self.WeatherInformation.cityName = cityToPassToDark?.cityname
                return self.darkServise.fetchWetherDataFromDarkSky(lat: (cityToPassToDark?.latitute)!, log: (cityToPassToDark?.longitude)!)
            }
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
//                self.WeatherInformation = self.settingsConfiguration.values(weatherObject: self.WeatherInformation)
                return (darkSkyData)
            })
            .subscribe(onNext: { (darkSkyData) in
                if darkSkyData.errorMessage == nil {
                    print("huh")
                    self.dataIsReady.onNext(true)
                    print(self.WeatherInformation)
                    
                } else{
                    self.errorOccured.onNext(true)
                }
            })
    }
    func chechForNewWeatherInformation() {
        self.darkSkyDownloadTrigger.onNext(true)
        
    }
    
    func openSearchView() {
        print("funcInitiated")
        self.searchCoordinatorDelegate?.OpenSearchView()
    }
    
    func openSettingsView(){
        self.settingsCoordinatorDelegate?.OpenSettingsView()
    }
    
}
