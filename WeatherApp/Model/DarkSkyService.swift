import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire


class DarkSkyService{
    let APIKey = "1b709f4ac6e851d85e8c6f53cf56c58c"
   
    
    
    func fetchWetherDataFromDarkSky(lat: String, log: String, cityName: String) -> Observable<DataAndErrorWrapper<WeatherDataToPresent>> {
         let url = URL(string: "https://api.darksky.net/\(self.APIKey)/\(lat),\(log)")
    }
    
}
