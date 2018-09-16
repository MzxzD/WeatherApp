//
//  TableViewCell+Extension.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 12/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import UIKit
protocol Identifiable{
    
}
extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}


