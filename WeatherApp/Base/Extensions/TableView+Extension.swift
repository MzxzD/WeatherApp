//
//  TableView+Extension.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 12/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import UIKit
extension UITableView {
    
    // dequeueing
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Can't dequeue cell with identifier: \(T.identifier)")
        }
        
        return cell
    }
    
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("Can't dequeue view with identifier: \(T.identifier)")
        }
        
        return view
    }
}
extension UITableViewHeaderFooterView: Identifiable{
    
}
extension UITableViewCell: Identifiable{
    
}
