//
//  SymptomViewModel.swift
//  WeatherApp
//
//  Created by Mateo Doslic on 16/09/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import Foundation
import RxSwift
import Realm
import RealmSwift


enum ItemsEnum{
    case headache
    case tiredness
    case rheumatism
    case noWill
}

enum TableTypes {
    case general
}

typealias ItemsNames = (type:ItemsEnum, name:String)
typealias ItemsNamesArray = Array<ItemsNames>

class SymptomViewModel: SymptomViewModelProtocol {
    var itemsToPresent: [TableSectionItem<TableTypes, TableTypes, ItemsNames>] = []
    var newSymptom = Symptoms()
    var realmServise = RealmSerivce()
    var delegate: SymptomCoordinator?
    var refreshView: PublishSubject<TableRefresh>
    let weather: Weather
        let itemsNameArray : ItemsNamesArray = [(type: .headache , name: "Headache scale :"), (type: .tiredness , name: "Tiredness scale :"), (type: .rheumatism , name: "Rheumatism scale :"), (type: .noWill , name: "No Will scale :")    ]
    
    
    init(weather: Weather) {
        
        for items in self.itemsNameArray{
            let tableItem: [TableItem<TableTypes, ItemsNames>] = [TableItem(type: TableTypes.general, data: items)]
            self.itemsToPresent += [TableSectionItem(type: TableTypes.general, sectionTitle: .empty, footerTitle: .empty, items: tableItem)]
            
        }
        
        self.weather = weather
        self.refreshView = PublishSubject()
    }
    
    
    func inputFinished(indexPath: IndexPath, input: String) {
        let dataToSave = itemsToPresent[indexPath.section].items[indexPath.row].data
        var inputData : String = ""
        if input == "" {
            inputData = "0"
        }else {
            inputData = input
        }
        switch dataToSave.type {
        case .headache:
            self.newSymptom.headache = Int(inputData)!
        case .tiredness:
            self.newSymptom.tiredness = Int(inputData)!
        case .rheumatism:
            self.newSymptom.rheumatism = Int(inputData)!

        case .noWill:
            self.newSymptom.noWill = Int(inputData)!

        }
    }
    
    func saveAndDissmissView() {
        let symptom = newSymptom
        symptom.date = Date()
        symptom.weather = self.weather
        if (!self.realmServise.create(object: symptom)){
            // ERROR
        }
        self.delegate?.dissmissView()
    }
}

protocol SymptomViewModelProtocol: TableRefreshViewModelProtocol, TableRowDelegate {
    var itemsToPresent: [TableSectionItem<TableTypes, TableTypes, ItemsNames>] {get}
    var delegate: SymptomCoordinator? {get set}
    var newSymptom: Symptoms {get}
    func saveAndDissmissView()
}




