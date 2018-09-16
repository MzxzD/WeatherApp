//
//  AnyClass+Extension.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 12/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import Foundation
extension NSObject {
    func printDeinit() {
        print("deinit:", String(describing: self))
    }
}
