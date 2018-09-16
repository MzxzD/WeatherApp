
struct DarkSkyResponse: Decodable {
    let currently : Currently!
    let daily : Daily!
}

struct Currently: Decodable {
    let time : Int
    let summary : String
    let icon : String
    let temperature : Double
    let humidity : Double
    let pressure : Double
    let windSpeed : Double
}


struct Daily: Decodable {
    let data : [WeatherData]
}


struct WeatherData: Decodable {
    let time : Int
    let temperatureHigh : Double
    let temperatureLow : Double
}
