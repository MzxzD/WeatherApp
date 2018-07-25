
import Realm
import RealmSwift


class WeatherDataToViewModel: Object {
    var currently: Currently?
    var daily: Daily?
    
}


class Weather: Object {
    @objc dynamic var cityName: String? = ""
    @objc dynamic var icon: String? = ""
    @objc dynamic var humidity: Double = 0
    @objc dynamic var pressure: Double = 0
    @objc dynamic var temperature: Double = 0
    @objc dynamic var time: Int = 0
    @objc dynamic var windSpeed: Double = 0
    @objc dynamic var summary: String? = ""
    @objc dynamic var temperatureMin: Double = 0
    @objc dynamic var temperatureMax: Double = 0
    
}
