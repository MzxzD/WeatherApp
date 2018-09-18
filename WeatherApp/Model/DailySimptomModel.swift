//
//  DailySimptomModel.swift
//  WeatherApp
//
//  Created by Mateo Doslic on 16/09/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Symptoms: Object {
    @objc dynamic var headache: Int = 0
    @objc dynamic var tiredness: Int = 0
    @objc dynamic var rheumatism: Int = 0 // Reuma
    @objc dynamic var noWill: Int = 0 // Bezvolja
    @objc dynamic var date: Date?
}
