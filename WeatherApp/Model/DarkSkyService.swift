import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire


class DarkSkyService{
    let APIKey = "1b709f4ac6e851d85e8c6f53cf56c58c"
   
    
    
    func fetchWetherDataFromDarkSky(lat: String, log: String, cityName: String) -> Observable<DataAndErrorWrapper<WeatherDataToPresent>> {
         let url = URL(string: "https://api.darksky.net/\(self.APIKey)/\(lat),\(log)")
        
        return RxAlamofire
            .data(.get, url!)
        
            .map({ (response) -> DataAndErrorWrapper<WeatherDataToPresent> in
                let decoder = JSONDecoder()
                var darkSkyResponse: [DarkSkyResponse] = []
                var dataToPresent: [WeatherDataToPresent] = []
                let responseJSON = response
                do {
                    let data = try decoder.decode(DarkSkyResponse.self, from: responseJSON)
                    darkSkyResponse = [data]
                }catch let error
                {
                    return DataAndErrorWrapper(data: [], errorMessage: error.localizedDescription)
                    
                }
                for dataFromDarkSky in darkSkyResponse {
                    dataToPresent = [WeatherDataToPresent(value: ["cityName": cityName, "currently": dataFromDarkSky.currently!, "daily": dataFromDarkSky.daily!])]
                }
                
                return DataAndErrorWrapper(data: dataToPresent, errorMessage: nil)
            })
        
    }
    
}
