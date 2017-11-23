//
//  CategoryDetailViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/5/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UIViewController{
    
    var selectedCategory = Category ()
    
    
    @IBOutlet weak var tbCategoryName: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedCategory.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}
