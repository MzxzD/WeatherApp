//
//  SymptopCoordinator.swift
//  WeatherApp
//
//  Created by Mateo Doslic on 16/09/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SymptomCoordinator: Coordinator {
    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
        let controller: SymptomViewController
    let weather: Weather
    
    init(presneter: UINavigationController, weather: Weather){
        self.presenter = presneter
        let  symptomViewController = SymptomViewController()
        let ViewModel = SymptomViewModel(weather: weather)
        symptomViewController.VM = ViewModel
        self.controller = symptomViewController
        self.weather = weather
    }
    
    func start() {        
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.presenter.dismiss(animated: false,completion:{
            self.controller.VM.delegate = self
            self.presenter.present(self.controller, animated: false)
        })
        
    }
    
}

extension SymptomCoordinator: DissmissViewDelegate{
    
    func dissmissView() {
//        self.presenter.dismiss(animated: true, completion: nil)
        let diaryCoordinator = DiaryCoordinator(presneter: self.presenter, weather: weather)
            diaryCoordinator.start()
    }
    
    func viewHasFinished() {
        childCoordinators.removeAll()
    }
    
    
    
    
}
