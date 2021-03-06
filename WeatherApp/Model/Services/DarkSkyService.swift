import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire


class DarkSkyService{
    let APIKey = "1b709f4ac6e851d85e8c6f53cf56c58c"
//   let lat = "45.554962"
//    let log = "18.695514"
    
    
    func fetchWetherDataFromDarkSky(lat: String, log: String) -> Observable<DataAndErrorWrapper<DarkSkyResponse>> {
//        func fetchWetherDataFromDarkSky() -> Observable<DataAndErrorWrapper<DarkSkyResponse>> {
            print("fetchWeather")
         let url = URL(string: "https://api.darksky.net/forecast/\(APIKey)/\(lat),\(log)")
        
        return RxAlamofire
            .data(.get, url!)
        
            .map({ (response) -> DataAndErrorWrapper<DarkSkyResponse> in
                let decoder = JSONDecoder()
                print(response)
                var darkSkyResponse: DarkSkyResponse = DarkSkyResponse(currently: nil, daily: nil)
                let responseJSON = response
                do {
                    let data = try decoder.decode(DarkSkyResponse.self, from: responseJSON)
                    darkSkyResponse = data
                }catch let error
                {
                    return DataAndErrorWrapper(data: darkSkyResponse, errorMessage: error.localizedDescription)
                    
                }
       
               
                
                return DataAndErrorWrapper(data: darkSkyResponse, errorMessage: nil)
            })
        
    }
    
}
