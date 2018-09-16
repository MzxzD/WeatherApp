import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire


class GeoNamesService{
    let maxRows = "8"
//    let q = "Osijek"
    let username = "mdoslic"
    var cityLocaton: [CityCoordinates] = []
    
    func fetchLatAndLogFromGeoNames(querry: String) -> Observable<DataAndErrorWrapper<[CityCoordinates]>> {
            let url = URL(string: "http://api.geonames.org/searchJSON?formatted=true&q=\(querry)&maxRows=\(maxRows)&lang=es&username=mdoslic&style=full")
        
        return RxAlamofire
            .data(.get, url!)

            .map({ (response) -> DataAndErrorWrapper<[CityCoordinates]> in
                let decoder = JSONDecoder()
                
                let responseJSON = response
              
                do {
                    let data = try decoder.decode(GeoNameBase.self, from: responseJSON)
         
                    let geoData  = data.geonames
                    for geoArrayData: Geonames in geoData! {
                        let temporarySavingArray = CityCoordinates()
                        temporarySavingArray.cityname = geoArrayData.asciiName
                        temporarySavingArray.latitute = geoArrayData.lat
                        temporarySavingArray.longitude = geoArrayData.lng
                        
                        self.cityLocaton.append(temporarySavingArray)
      
                    }
                  
                }catch let error
                {
            
                    return DataAndErrorWrapper(data: self.cityLocaton, errorMessage: error.localizedDescription)
                }
                return DataAndErrorWrapper(data: self.cityLocaton, errorMessage: nil)
            })
            .catchError({ (error) -> Observable<DataAndErrorWrapper<[CityCoordinates]>> in
                return Observable.just(DataAndErrorWrapper(data: self.cityLocaton , errorMessage: error.localizedDescription))
            })
    }
    
    
    
    
    
    
    
    
}
