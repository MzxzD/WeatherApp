//
//  TableRefresh.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 12/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import UIKit

enum TableRefresh {
    case complete
    case reloadRows(indexPaths: [IndexPath])
    case updateRows(indexPaths: [IndexPath])
    case section(section: Int, withAnimation: UITableViewRowAnimation )
    case addRows(indexPaths: [IndexPath], withAnimation: UITableViewRowAnimation)
    case removeRows(indexPaths: [IndexPath], withAnimation: UITableViewRowAnimation)
    case addSection(withIndex:Int)
    case removeSection(withIndex:Int)
    case dontRefresh
    case multipleActions(removeIndexes:[IndexPath], addIndexes:[IndexPath],modifiedIndexes:[IndexPath])
}
