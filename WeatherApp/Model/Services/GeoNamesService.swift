import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire


class GeoNamesService{
    let maxRows = "maxRows=3"
    let q = "q=Osijek"
    let username = "username=mdoslic"
    

    
    func fetchLatAndLogFromGeoNames() -> Observable<DataAndErrorWrapper<CityCoordinates>> {
//            let url = URL(string: "http://api.geonames.org/searchJSON?formatted=true&\(self.q)&\(self.maxRows)&lang=es&\(self.username)&style=full")
        let url = URL(string: "http://api.geonames.org/searchJSON?formatted=true&q=Zagreb&maxRows=3&lang=es&username=mdoslic&style=full")
        
        
        print("entered GEO")
        return RxAlamofire
            .data(.get, url!)
        
            .map({ (response) -> DataAndErrorWrapper<CityCoordinates> in
                let decoder = JSONDecoder()
                var geoNames: GeoNames = GeoNames(asciiName: "", lat: "", lng: "", alternateNames: [])
                var cityLocaton: CityCoordinates = CityCoordinates(latitute: "", longitude: "", cityname: "")
                let responseJSON = response
                do {
                    let data = try decoder.decode(GeoNamesResponse.self, from: responseJSON)
                    geoNames = data.geonames
                }catch let error
                {
                    return DataAndErrorWrapper(data: cityLocaton, errorMessage: error.localizedDescription)
                }
                    cityLocaton = CityCoordinates(latitute: geoNames.lat, longitude: geoNames.lng, cityname: geoNames.asciiName)
                
                
                return DataAndErrorWrapper(data: cityLocaton, errorMessage: nil)
            })
            .catchError({ (error) -> Observable<DataAndErrorWrapper<CityCoordinates>> in
                return Observable.just(DataAndErrorWrapper(data: CityCoordinates(latitute: "", longitude: "", cityname: ""), errorMessage: error.localizedDescription))
            })
    }
    
    
    
    
    
    
    
    
}
