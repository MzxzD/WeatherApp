//
//  Collections+Extension.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 05/07/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import Foundation
extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
