//
//  SearchCoordinator.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//


import Foundation
import UIKit

class SearchCoordinator: Coordinator {
    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    let controller: SearchViewController
    
    init(presneter: UINavigationController){
        self.presenter = presneter
        let searchViewController = SearchViewController()
        let searchViewModel = SearchViewModel()
        searchViewController.searchViewModel = searchViewModel
        self.controller = searchViewController
    }
    
    func start() {
        print(self.presenter.present(controller, animated: true))
    }
    
    
}
