//
//  SettingsViewModel.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift


class SettingsViewModel {

    var settingsCoordinatorDelegate: DissmissViewDelegate?
    
    
    
    func dissmissTheView() {
        print("canceling....")
        self.settingsCoordinatorDelegate?.dissmissView()
    }
    
    
}
