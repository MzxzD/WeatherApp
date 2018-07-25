import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire


class GeoNamesService{
    let maxRows = "maxRows=5"
    let q = "q=Osijek"
    let username = "username=mdoslic"
    
    let url = URL(string: "http://api.geonames.org/searchJSON?formatted=true&\(q)&\(maxRows)&lang=es&\(username)&style=full")
    
    func fetchLatAndLogFromGeoNames() -> Observable<> {
        
    }
    
    
    
    
    
    
    
    
}
