//
//  HomeCoordinator.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class HomeCoordinator: Coordinator {
    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    let controller: HomeViewController
    var searchViewDelegate: SearchViewDelegate?
    
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
    
    func weatherDownloadTrigger(){
        controller.homeViewModel.darkSkyDownloadTrigger.onNext(true)

    }
    
    func openSearchView() {
        let searchCoordinator = SearchCoordinator(presneter: self.presenter)
        searchCoordinator.start()
        searchCoordinator.searchViewDelegate = self
        self.addChildCoordinator(childCoordinator: searchCoordinator)
    }
    
    func viewHasFinished() {
        self.childCoordinators.removeAll()
    }
    
}

extension HomeCoordinator: SettingsViewDelegate {
    
    func openSettingsView(weather: Weather) {
        print("here we go!")
        let settingsCoordinator = SettingsCoordinator(presneter: self.presenter, weather: weather)
        settingsCoordinator.start()
        settingsCoordinator.settingsViewDelegate = self
        self.addChildCoordinator(childCoordinator: settingsCoordinator)
    }
    
}
