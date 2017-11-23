//
//  Category.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 10/23/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import Foundation
import RealmSwift


class Category : Object {
    
    @objc dynamic var name = ""
    @objc dynamic var isDefault : Bool = true
    let pictures = List <Picture>()
    
    
}
