//
//  Answer.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 10/23/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import Foundation
import UIKit


class Answer{
    
    var image : UIImage
    var isCorrect = true
    var imageCorrect: UIImage
    var isSelected = false
    var category : Category!
    
    init(image: UIImage, isCorrect: Bool){
        
        self.image = image
        self.isCorrect = isCorrect
        self.imageCorrect = image.tint(tintColor: UIColor(red: 63/255, green: 195/255, blue: 128/255, alpha: 1))
        
    }
    
}
