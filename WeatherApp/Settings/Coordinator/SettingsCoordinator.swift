//
//  SettingsCoordinator.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SettingsCoordinator: Coordinator {
    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    let controller: SettingsViewController
    var settingsViewDelegate: SettingsViewDelegate?
    var DiaryDelegate: DiaryCoordinatorDelegate?
    let weather: Weather


    
    init(presneter: UINavigationController, weather: Weather){
        self.presenter = presneter
        let settingsViewController = SettingsViewController()
        let settingsViewModel = SettingsViewModel(weather: weather)
        settingsViewController.settingsViewModel = settingsViewModel
        self.controller = settingsViewController
        self.weather = weather
    }
    
    func start() {
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        controller.settingsViewModel.settingsCoordinatorDelegate = self
        controller.settingsViewModel.diaryDelegate = self
        print(self.presenter.present(controller, animated: false))
    }
    
}

extension SettingsCoordinator: DissmissViewDelegate, DiaryCoordinatorDelegate{
    func openDiaryView() {
        let diaryCoordinator = DiaryCoordinator(presneter: presenter, weather: self.weather)
        diaryCoordinator.start()
        addChildCoordinator(childCoordinator: diaryCoordinator)
    }
    

    func dissmissView() {
        self.presenter.dismiss(animated: true,completion:{
            self.settingsViewDelegate?.weatherDownloadTrigger()
        })
    }
    
    func viewHasFinished() {
        childCoordinators.removeAll()
    }
    
}
