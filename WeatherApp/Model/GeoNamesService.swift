import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire


class GeoNamesService{
    let maxRows = "maxRows=1"
    let q = "q=Osijek"
    let username = "username=mdoslic"
    

    
    func fetchLatAndLogFromGeoNames() -> Observable<DataAndErrorWrapper<CityCoordinates>> {
            let url = URL(string: "http://api.geonames.org/searchJSON?formatted=true&\(self.q)&\(self.maxRows)&lang=es&\(self.username)&style=full")
        
        return RxAlamofire
            .data(.get, url!)
        
            .map({ (response) -> DataAndErrorWrapper<CityCoordinates> in
                let decoder = JSONDecoder()
                var geoNames: [GeoNames] = []
                var cityLocaton: [CityCoordinates] = []
                let responseJSON = response
                do {
                    let data = try decoder.decode(GeoNamesResponse.self, from: responseJSON)
                    geoNames = data.geonames
                }catch let error
                {
                    for cities in geoNames{
                        cityLocaton = [CityCoordinates(latitute: cities.lat, longitude: cities.lng, cityname: cities.asciiName)]
                    }
                    return DataAndErrorWrapper(data: [], errorMessage: error.localizedDescription)
                }
                
                return DataAndErrorWrapper(data: cityLocaton, errorMessage: nil)
            })
            .catchError({ (error) -> Observable<DataAndErrorWrapper<CityCoordinates>> in
                return Observable.just(DataAndErrorWrapper(data: [], errorMessage: error.localizedDescription))
            })
    }
    
    
    
    
    
    
    
    
}
