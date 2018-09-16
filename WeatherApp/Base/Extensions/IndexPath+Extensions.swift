//
//  IndexPath.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 12/07/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import Foundation
extension IndexPath {
   static func  createIndexPaths(section: Int, rows: [Int]) -> [IndexPath]{
    return rows.map({ (index) -> IndexPath in
        return IndexPath(row: index, section: section)
    })
    }
}
