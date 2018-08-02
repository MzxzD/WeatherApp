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
    
    init(presneter: UINavigationController){
        self.presenter = presneter
        let settingsViewController = SettingsViewController()
        let settingsViewModel = SettingsViewModel()
        settingsViewController.settingsViewModel = settingsViewModel
        self.controller = settingsViewController
    }
    
    func start() {
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        controller.settingsViewModel.settingsCoordinatorDelegate = self
        print(self.presenter.present(controller, animated: false))
    }
    
}

extension SettingsCoordinator: DissmissViewDelegate{

    func dissmissView() {
        self.presenter.dismiss(animated: true,completion:{
            self.settingsViewDelegate?.weatherDownloadTrigger()
        })
    }
    
    func viewHasFinished() {
        childCoordinators.removeAll()
    }
    
}
