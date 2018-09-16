struct GeoNamesResponse: Decodable {
    let totalResultsCount: Int
    let geonames: GeoNames
}

struct GeoNames: Decodable {

    var asciiName : String?
    var lat : String?
    var lng : String?
//    let alternateNames : [AlternateNames]?

}

//struct AlternateNames: Decodable {
//    let name : String?
//    let lang : String?
//}


