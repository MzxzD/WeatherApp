/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Geonames : Codable {
	let timezone : Timezone?
	let bbox : Bbox?
	let asciiName : String?
	let astergdem : Int?
	let countryId : String?
	let fcl : String?
	let srtm3 : Int?
	let score : Double?
	let countryCode : String?
//    let adminCodes1 : AdminCodes1?
	let adminId1 : String?
	let lat : String?
	let fcode : String?
	let continentCode : String?
	let adminCode2 : String?
	let adminCode1 : String?
	let lng : String?
	let geonameId : Int?
	let toponymName : String?
	let population : Int?
	let adminName5 : String?
	let adminName4 : String?
	let adminName3 : String?
	let alternateNames : [AlternateNames]?
	let adminName2 : String?
	let name : String?
	let fclName : String?
	let countryName : String?
	let fcodeName : String?
	let adminName1 : String?

	enum CodingKeys: String, CodingKey {

		case timezone = "timezone"
		case bbox = "bbox"
		case asciiName = "asciiName"
		case astergdem = "astergdem"
		case countryId = "countryId"
		case fcl = "fcl"
		case srtm3 = "srtm3"
		case score = "score"
		case countryCode = "countryCode"
//        case adminCodes1 = "adminCodes1"
		case adminId1 = "adminId1"
		case lat = "lat"
		case fcode = "fcode"
		case continentCode = "continentCode"
		case adminCode2 = "adminCode2"
		case adminCode1 = "adminCode1"
		case lng = "lng"
		case geonameId = "geonameId"
		case toponymName = "toponymName"
		case population = "population"
		case adminName5 = "adminName5"
		case adminName4 = "adminName4"
		case adminName3 = "adminName3"
		case alternateNames = "alternateNames"
		case adminName2 = "adminName2"
		case name = "name"
		case fclName = "fclName"
		case countryName = "countryName"
		case fcodeName = "fcodeName"
		case adminName1 = "adminName1"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		timezone = try values.decodeIfPresent(Timezone.self, forKey: .timezone)
		bbox = try values.decodeIfPresent(Bbox.self, forKey: .bbox)
		asciiName = try values.decodeIfPresent(String.self, forKey: .asciiName)
		astergdem = try values.decodeIfPresent(Int.self, forKey: .astergdem)
		countryId = try values.decodeIfPresent(String.self, forKey: .countryId)
		fcl = try values.decodeIfPresent(String.self, forKey: .fcl)
		srtm3 = try values.decodeIfPresent(Int.self, forKey: .srtm3)
		score = try values.decodeIfPresent(Double.self, forKey: .score)
		countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
//        adminCodes1 = try values.decodeIfPresent(AdminCodes1.self, forKey: .adminCodes1)
		adminId1 = try values.decodeIfPresent(String.self, forKey: .adminId1)
		lat = try values.decodeIfPresent(String.self, forKey: .lat)
		fcode = try values.decodeIfPresent(String.self, forKey: .fcode)
		continentCode = try values.decodeIfPresent(String.self, forKey: .continentCode)
		adminCode2 = try values.decodeIfPresent(String.self, forKey: .adminCode2)
		adminCode1 = try values.decodeIfPresent(String.self, forKey: .adminCode1)
		lng = try values.decodeIfPresent(String.self, forKey: .lng)
		geonameId = try values.decodeIfPresent(Int.self, forKey: .geonameId)
		toponymName = try values.decodeIfPresent(String.self, forKey: .toponymName)
		population = try values.decodeIfPresent(Int.self, forKey: .population)
		adminName5 = try values.decodeIfPresent(String.self, forKey: .adminName5)
		adminName4 = try values.decodeIfPresent(String.self, forKey: .adminName4)
		adminName3 = try values.decodeIfPresent(String.self, forKey: .adminName3)
		alternateNames = try values.decodeIfPresent([AlternateNames].self, forKey: .alternateNames)
		adminName2 = try values.decodeIfPresent(String.self, forKey: .adminName2)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		fclName = try values.decodeIfPresent(String.self, forKey: .fclName)
		countryName = try values.decodeIfPresent(String.self, forKey: .countryName)
		fcodeName = try values.decodeIfPresent(String.self, forKey: .fcodeName)
		adminName1 = try values.decodeIfPresent(String.self, forKey: .adminName1)
	}

}
