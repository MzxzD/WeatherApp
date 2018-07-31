import Realm
import RealmSwift


class SettingsConfiguration: Object {
    var unit: UnitSystem = UnitSystem(rawValue: false)!
    var humidityIsShown: Bool = true
    var windIsShown: Bool = true
    var pressureIsShown: Bool = true
}


enum UnitSystem: Bool {
    case Metric = false
    case Imperial = true
    
    func values(weatherObject: Weather) -> Weather {
        switch self {
        case .Metric:
            var metricWeatherObject = weatherObject
            metricWeatherObject.windSpeed = metricWeatherObject.windSpeed * 1.609344
            metricWeatherObject.temperature = (metricWeatherObject.temperature - 32) * (5/9)
            metricWeatherObject.temperatureMax = (metricWeatherObject.temperatureMax - 32) * (5/9)
            metricWeatherObject.temperatureMin = (metricWeatherObject.temperatureMin - 32) * (5/9)
            
            return metricWeatherObject
        
        case .Imperial:
            return weatherObject
            
        }
    }
}

