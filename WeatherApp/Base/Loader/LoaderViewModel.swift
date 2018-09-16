//
//  LoaderViewModel.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 04/07/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import Foundation
import RxSwift
protocol LoaderViewModelProtocol {
    var loaderPublisher: PublishSubject<Bool> {get}
}
