//
//  SettingsModel.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/15/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsModel : Object {
    
    @objc dynamic var numberOfPicturesForDisplay = 4
    
    
    func obtainSetup() -> Int{
        
        var picturesAcross = 0
        switch numberOfPicturesForDisplay {
            case 4, 6 : picturesAcross = 2
            case 12  : picturesAcross = 3
            default: picturesAcross = 0
        }
        
        return picturesAcross
    }
    
    
}
