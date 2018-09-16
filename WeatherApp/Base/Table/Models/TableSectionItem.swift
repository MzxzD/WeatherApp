//
//  TableSectionItem.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 12/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//
import Foundation
public struct TableSectionItem<SectionType,ItemType, ItemData>{
    let type: SectionType
    let sectionTitle: String
    let footerTitle: String
    var items: [TableItem<ItemType,ItemData>]
}
