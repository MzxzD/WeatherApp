
struct DarkSkyResponse: Decodable {
//    let latitude : Double?
//    let longitude : Double?
//    let timezone : String?
    let currently : Currently?
    let daily : Daily?
//    let flags : Flags?
//    let offset : Int?
}


struct Currently: Decodable {
    let time : Int?
    let summary : String?
    let icon : String?
//    let precipIntensity : Int?
//    let precipProbability : Int?
    let temperature : Double?
//    let apparentTemperature : Double?
//    let dewPoint : Double?
    let humidity : Double?
    let pressure : Double?
    let windSpeed : Double?
//    let windGust : Double?
//    let windBearing : Int?
//    let cloudCover : Double?
//    let uvIndex : Int?
//    let visibility : Int?
//    let ozone : Double?
}


struct Daily: Decodable {
//    let summary : String?
//    let icon : String?
    let data : [WeatherData]?
}

//struct Flags: Decodable {
//    let sources : [String]?
//    let nearest-station : Double?
//    let units : String?
//}

struct WeatherData: Decodable {
    let time : Int?
//    let summary : String?
//    let icon : String?
//    let sunriseTime : Int?
//    let sunsetTime : Int?
//    let moonPhase : Double?
//    let precipIntensity : Double?
//    let precipIntensityMax : Double?
//    let precipIntensityMaxTime : Int?
//    let precipProbability : Double?
//    let precipType : String?
    let temperatureHigh : Double?
//    let temperatureHighTime : Int?
    let temperatureLow : Double?
//    let temperatureLowTime : Int?
//    let apparentTemperatureHigh : Double?
//    let apparentTemperatureHighTime : Int?
//    let apparentTemperatureLow : Double?
//    let apparentTemperatureLowTime : Int?
//    let dewPoint : Double?
//    let humidity : Double?
//    let pressure : Double?
//    let windSpeed : Double?
//    let windGust : Double?
//    let windGustTime : Int?
//    let windBearing : Int?
//    let cloudCover : Double?
//    let uvIndex : Int?
//    let uvIndexTime : Int?
//    let visibility : Int?
//    let ozone : Double?
//    let temperatureMin : Double?
//    let temperatureMinTime : Int?
//    let temperatureMax : Double?
//    let temperatureMaxTime : Int?
//    let apparentTemperatureMin : Double?
//    let apparentTemperatureMinTime : Int?
//    let apparentTemperatureMax : Double?
//    let apparentTemperatureMaxTime : Int?
}
