struct GeoNamesResponse: Decodable {
    let totalResultsCount: Int
    let geonames: GeoNames
}

struct GeoNames: Decodable {

    let asciiName : String?
    let lat : String?
    let lng : String?
    let alternateNames : [AlternateNames]?

}

struct AlternateNames: Decodable {
    let name : String?
    let lang : String?
}


