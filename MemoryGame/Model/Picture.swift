//
//  Picture.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 10/23/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import Foundation
import RealmSwift


class Picture : Object {
    
    @objc dynamic var pictureData : NSData? = nil //Picture data is not an optional value
    @objc dynamic var canBeDeleted : Bool = true
    
    
    
}
