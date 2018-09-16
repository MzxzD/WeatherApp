//
//  CoordinatorDelegate.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation

protocol CoordinatorDelegate: class {
    func viewHasFinished()
}

protocol ParentCoordinatorDelegate: class {
    func childHasFinished(coordinator: Coordinator)
}
