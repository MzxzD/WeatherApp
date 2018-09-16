//
//  TableRefreshViewModel.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 12/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//
import RxSwift
protocol TableRefreshViewModelProtocol {
    var refreshView: PublishSubject<TableRefresh> {get}
}
