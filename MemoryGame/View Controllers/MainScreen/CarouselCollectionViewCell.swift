//
//  CarouselCollectionViewCell.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/16/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var customView: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var textViewDescription: UITextView!
    
    
    static let identifier = "CarouselCollectionViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 10
    }
}
