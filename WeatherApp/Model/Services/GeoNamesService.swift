import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire


class GeoNamesService{
    let maxRows = "3"
    let q = "Osijek"
    let username = "mdoslic"
    

    
    func fetchLatAndLogFromGeoNames() -> Observable<DataAndErrorWrapper<CityCoordinates>> {
            let url = URL(string: "http://api.geonames.org/searchJSON?formatted=true&q=\(self.q)&maxRows=\(self.maxRows)&lang=es&username=\(self.username)&style=full")
        
        
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
