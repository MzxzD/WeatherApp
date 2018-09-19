import RealmSwift
import Realm



class Configuration: Object {
    @objc dynamic var unit: Bool = false
    @objc dynamic var humidityIsHidden: Bool = false
    @objc dynamic var windIsHidden: Bool = false
    @objc dynamic var pressureIsHidden: Bool = false
    
    func values(weatherObject: Weather) -> Weather {
        switch unit {
        case false :
            let metricWeatherObject = weatherObject
            metricWeatherObject.windSpeed = (metricWeatherObject.windSpeed * 1.609344).rounded()
            metricWeatherObject.temperature = (Int((Float(metricWeatherObject.temperature) - 32) * (5/9)))
            metricWeatherObject.temperatureMax = ((metricWeatherObject.temperatureMax - 32) * (5/9)).rounded()
            metricWeatherObject.temperatureMin = ((metricWeatherObject.temperatureMin - 32) * (5/9)).rounded()
            
            return metricWeatherObject
            
        case true:
            return weatherObject
            
        }
    }
    
}


enum UnitSystem {
    case Metric
    case Imperial

    var value: Bool{
        switch self {
        case .Metric:
            return false
        case .Imperial:
            return true
        }
    }
}

