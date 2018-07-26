
import UIKit


struct Weather  {
    var cityName: String? = nil
    var icon: icon?
    var humidity: Double = 0
    var pressure: Int = 0
    var temperature: Int = 0
    var time: Int = 0
    var windSpeed: Double = 0
    var summary: String = ""
    var temperatureMin: Double = 0
    var temperatureMax: Double = 0
    var backgroundColor: UIColor?
    var headerImage: UIImage?
    var bodyImage: UIImage?
    
}


enum icon : String{
    case clearDay = "clear-day"
    case clearNight = "clear-ight"
    case cloudy = "cloudy"
    case fog = "fog"
    case hail = "hail"
    case partiallyCloudyDay = "partly-cloudy-day"
    case partiallyCloudyNight  = "partly-cloudy-night"
    case rain = "rain"
    case sleet = "sleet"
    case snow = "snow"
    case thunderstorm = "thunderstorm"
    case wind = "wind"

    func values () -> (bodyWeatherImage:UIImage,headerWeatherImaage:UIImage, color: UIColor){
        switch self {
        case .clearDay:
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-clear-day") ,headerWeatherImaage: #imageLiteral(resourceName: "header_image-clear-day"), color: UIColor(red:0.35, green:0.72, blue:0.88, alpha:1.0)) // DAY
        case .clearNight :
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-clear-night"), headerWeatherImaage: #imageLiteral(resourceName: "header_image-clear-night"), color: UIColor(red:0.02, green:0.27, blue:0.39, alpha:1.0)) // NIGHT
        case .cloudy :
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-cloudy"), headerWeatherImaage: #imageLiteral(resourceName: "header_image-cloudy"),  color: UIColor.gray)
        case .fog :
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-fog"), headerWeatherImaage: #imageLiteral(resourceName: "header_image-fog.png"), color :UIColor(red:0.67, green:0.84, blue:0.91, alpha:1.0)) // FOG
        case .hail :
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-hail"), headerWeatherImaage: #imageLiteral(resourceName: "header_image-hail"),  color : UIColor(red:0.04, green:0.23, blue:0.31, alpha:1.0))
        case .partiallyCloudyDay:
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-partly-cloudy-day"), headerWeatherImaage: #imageLiteral(resourceName: "header_image-partly-cloudy-day"), color:UIColor.lightGray)
        case .partiallyCloudyNight:
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-partly-cloudy-night"), headerWeatherImaage: #imageLiteral(resourceName: "header_image-partly-cloudy-night"), color:UIColor.darkGray)
        case .rain:
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-rain"), headerWeatherImaage: #imageLiteral(resourceName: "header_image-rain"), color:UIColor(red:0.08, green:0.35, blue:0.48, alpha:1.0)) // RAIN
        case .sleet:
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-sleet"), headerWeatherImaage: #imageLiteral(resourceName: "header_image-sleet.png"), color:UIColor(red:0.04, green:0.23, blue:0.31, alpha:1.0))
        case .snow:
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-snow"), headerWeatherImaage: #imageLiteral(resourceName: "header_image-snow"), color:UIColor(red:0.04, green:0.23, blue:0.31, alpha:1.0)) // SNOW
        case .thunderstorm:
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-thunderstorm"), headerWeatherImaage: #imageLiteral(resourceName: "header_image-thunderstorm"), color:UIColor(red:0.04, green:0.23, blue:0.31, alpha:1.0))
        default: //wind
            return (bodyWeatherImage: #imageLiteral(resourceName: "body_image-wind"), headerWeatherImaage: #imageLiteral(resourceName: "header_image-wind"), color:UIColor(red:0.35, green:0.72, blue:0.88, alpha:1.0))
        }
    }
}

