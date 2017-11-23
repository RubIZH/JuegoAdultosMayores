//
//  PreviewViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 10/22/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    var imageView = UIImageView()
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
                
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.frame = self.view.bounds
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        
    }
    
}

