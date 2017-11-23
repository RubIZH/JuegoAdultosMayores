//
//  ImageCollectionViewCell.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 10/22/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var answer: Answer!
    var image: UIImage? {
        didSet {
            if let image = image {
                 imageView.image = image
            }
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds
        
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = self.frame.height/2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// Setting up the view
    func setup() {

        self.addStyle()
        self.addSubview(imageView)
    }
    


    
    private func addStyle(){
        
        self.contentView.layer.cornerRadius = self.frame.height/2
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
        
    }
    
    
    
}

