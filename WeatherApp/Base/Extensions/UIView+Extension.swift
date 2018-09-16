//
//  UIView+Extension.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 12/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import UIKit
extension UIView {
    func addSubviews(_ views: UIView...){
        for view in views{
            self.addSubview(view)
        }
    }
}
