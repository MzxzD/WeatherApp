
import Realm
import RealmSwift


class WeatherDataToPresent: Object {
    @objc dynamic var cityName: String? = ""
    var currently: Currently?
    var daily: Daily?
    
}
