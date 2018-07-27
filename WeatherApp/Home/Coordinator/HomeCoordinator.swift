//
//  HomeCoordinator.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    let controller: HomeViewController
    
    init(presneter: UINavigationController){
        self.presenter = presneter
        let homeViewController = HomeViewController()
        let homeViewModel = HomeViewModel()
        homeViewController.homeViewModel = homeViewModel
        self.controller = homeViewController
    }
    
    func start() {
        controller.homeViewModel.searchCoordinatorDelegate = self
        controller.homeViewModel.settingsCoordinatorDelegate = self
        presenter.pushViewController(controller, animated: true)
    }
    
    
}

extension HomeCoordinator: SearchViewDelegate {


    func OpenSearchView() {
        print("here we go!")
        let searchCoordinator = SearchCoordinator(presneter: self.presenter)
        searchCoordinator.start()
        self.addChildCoordinator(childCoordinator: searchCoordinator)
    }
    
    func viewHasFinished() {
//        self.childCoordinator.removeAll()
//        parentCoordinatorDelegate?.childHasFinished(coordinator: self)
    }
    
    
}

extension HomeCoordinator: SettingsViewDelegate {
    func OpenSettingsView() {
        print("here we go!")
        let settingsCoordinator = SettingsCoordinator(presneter: self.presenter)
        settingsCoordinator.start()
        self.addChildCoordinator(childCoordinator: settingsCoordinator)
    }
    
}
