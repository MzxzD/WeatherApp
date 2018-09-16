//
//  SearchCoordinator.swift
//  WeatherApp
//
//  Created by Mateo Došlić on 27/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//


import Foundation
import UIKit
import RxSwift

class SearchCoordinator: Coordinator {
    var presenter: UINavigationController
    var childCoordinators: [Coordinator] = []
    let controller: SearchViewController
    var searchViewDelegate: SearchViewDelegate?
    
    init(presneter: UINavigationController){
        self.presenter = presneter
        let searchViewController = SearchViewController()
        let searchViewModel = SearchViewModel()
        searchViewController.searchViewModel = searchViewModel
        self.controller = searchViewController
    }
    
    func start() {
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        controller.searchViewModel.searchCoordinatorDelegate = self
        self.presenter.present(controller, animated: false)
    }
    
}

extension SearchCoordinator: DissmissViewDelegate{
    
    func dissmissView() {
        
        
        
        self.presenter.dismiss(animated: true , completion: {
            self.searchViewDelegate?.weatherDownloadTrigger()
            })
    }

    func viewHasFinished() {
        childCoordinators.removeAll()
    }
    
    
    
}
