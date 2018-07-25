import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire


class DarkSkyService{
    let APIKey = "1b709f4ac6e851d85e8c6f53cf56c58c"
   let lat = "42.3601"
    let log = "-71.0589"
    
    
//    func fetchWetherDataFromDarkSky(lat: String, log: String) -> Observable<DataAndErrorWrapper<WeatherDataToViewModel>> {
        func fetchWetherDataFromDarkSky() -> Observable<DataAndErrorWrapper<WeatherDataToViewModel>> {
         let url = URL(string: "https://api.darksky.net/forecast/1b709f4ac6e851d85e8c6f53cf56c58c/42.3601,-71.0589")
        
        return RxAlamofire
            .data(.get, url!)
        
            .map({ (response) -> DataAndErrorWrapper<WeatherDataToViewModel> in
                let decoder = JSONDecoder()
                print(response)
                var darkSkyResponse: DarkSkyResponse = DarkSkyResponse(currently: nil, daily: nil)
                var dataToPresent: WeatherDataToViewModel = WeatherDataToViewModel()
                let responseJSON = response
                do {
                    let data = try decoder.decode(DarkSkyResponse.self, from: responseJSON)
                    darkSkyResponse = data
                }catch let error
                {
                    return DataAndErrorWrapper(data: dataToPresent, errorMessage: error.localizedDescription)
                    
                }
       
                    dataToPresent = WeatherDataToViewModel(value: ["currently": darkSkyResponse.currently!, "daily": darkSkyResponse.daily!])
                
                
                return DataAndErrorWrapper(data: dataToPresent, errorMessage: nil)
            })
        
    }
    
}
