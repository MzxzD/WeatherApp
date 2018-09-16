//
//  SettingsViewDelegate.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation

protocol SettingsViewDelegate: CoordinatorDelegate {
    func openSettingsView(weather: Weather)
    func weatherDownloadTrigger()
}
