import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire


class GeoNamesService{
    let maxRows = "3"
//    let q = "Osijek"
    let username = "mdoslic"

    
    func fetchLatAndLogFromGeoNames(querry: String) -> Observable<DataAndErrorWrapper<CityCoordinates>> {
            let url = URL(string: "http://api.geonames.org/searchJSON?formatted=true&q=\(querry)&maxRows=3&lang=es&username=mdoslic&style=full")

        
        return RxAlamofire
            .data(.get, url!)

            .map({ (response) -> DataAndErrorWrapper<CityCoordinates> in
                let decoder = JSONDecoder()
//                var geoNames: [GeoNames] = []
                var cityLocaton: [CityCoordinates] = []
                let responseJSON = response
                print("prijeFO")
                do {
                    let data = try decoder.decode(Json4Swift_Base.self, from: responseJSON)
                    print("DO")
                    let geoData  = data.geonames
                    for geoArrayData: Geonames in geoData! {
//                        cityLocaton += [CityCoordinates(values: asciiName: geoArrayData.asciiName , lat: geoArrayData.lat, lng: geoArrayData.lng ) ]
                    }
                  
                 
                    
                }catch let error
                {
                    print("Catch")
                    return DataAndErrorWrapper(data: geoNames, errorMessage: error.localizedDescription)
                }
//                cityLocaton = CityCoordinates(value: ["latitute": geoNames.lat, "longitude": geoNames.lng, "cityname": geoNames.asciiName])
                
                return DataAndErrorWrapper(data: cityLocaton, errorMessage: nil)
            })
            .catchError({ (error) -> Observable<DataAndErrorWrapper<CityCoordinates>> in
                return Observable.just(DataAndErrorWrapper(data: [] , errorMessage: error.localizedDescription))
            })
    }
    
    
    
    
    
    
    
    
}
