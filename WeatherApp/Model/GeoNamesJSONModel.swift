struct GeoNamesResponse: Decodable {
    let totalResultsCount: Int
    let geonames: GeoNames
}


struct GeoNames: Decodable {
//    let timezone : Timezone?
//    let bbox : Bbox?
    let asciiName : String?
//    let astergdem : Int?
//    let countryId : String?
//    let fcl : String?
//    let srtm3 : Int?
//    let score : Double?
//    let countryCode : String?
//    let adminCodes1 : AdminCodes1?
//    let adminId1 : String?
    let lat : String?
//    let fcode : String?
//    let continentCode : String?
//    let adminCode2 : String?
//    let adminCode1 : String?
    let lng : String?
//    let geonameId : Int?
//    let toponymName : String?
//    let population : Int?
//    let adminName5 : String?
//    let adminName4 : String?
//    let adminName3 : String?
    let alternateNames : [AlternateNames]?
//    let adminName2 : String?
//    let name : String?
//    let fclName : String?
//    let countryName : String?
//    let fcodeName : String?
//    let adminName1 : String?
    
}


//struct Timezone: Decodable {
//    let gmtOffset : Int?
//    let timeZoneId : String?
//    let dstOffset : Int?
//}
//
//struct Bbox: Decodable {
//    let east : Double?
//    let south : Double?
//    let north : Double?
//    let west : Double?
//    let accuracyLevel : Int?
//}
//
//struct AdminCodes1: Decodable {
//    let iSO3166_2 : String?
//}

struct AlternateNames: Decodable {
    let name : String?
    let lang : String?
}


