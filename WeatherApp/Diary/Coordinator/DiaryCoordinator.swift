//
//  DiaryCoordinator.swift
//  WeatherApp
//
//  Created by Mateo Doslic on 16/09/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class DiaryCoordinator: Coordinator {
    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    let controller: DiaryViewViewController
    var symptomCoordinatorDelegate: SymptomCoordinatorDelegate?
    let weather: Weather?
    
    init(presneter: UINavigationController, weather: Weather){
        self.presenter = presneter
        let diaryViewController = DiaryViewViewController()
        let diaryViewModel = DiaryViewModel()
        diaryViewController.VM = diaryViewModel
        self.controller = diaryViewController
        self.weather = weather
    }
    
    func start() {
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.presenter.dismiss(animated: false,completion:{
            self.controller.VM.symptomDelegate = self
             self.controller.VM.dissmissDelegate = self
            self.presenter.present(self.controller, animated: false)
        })
        
    }
    
}

extension DiaryCoordinator: DissmissViewDelegate, SymptomCoordinatorDelegate{
    func openSymptomView() {
        let symptomCoordinator = SymptomCoordinator(presneter: presenter, weather: self.weather!)
        symptomCoordinator.start()
        addChildCoordinator(childCoordinator: symptomCoordinator)
    }
    
    
    func dissmissView() {
        
        self.presenter.dismiss(animated: false) {
            let settingsCoordinator = SettingsCoordinator(presneter: self.presenter, weather: self.weather!)
            settingsCoordinator.start()
        }
    }
    
    
    func viewHasFinished() {
        childCoordinators.removeAll()
    }
    
    
    
}
