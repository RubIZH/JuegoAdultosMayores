//
//  SettingsTableViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/16/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    private func setupNavigationBar(){

        
        var colors = [UIColor]()
        colors.append(UIColor(red: 88/255, green: 0/255, blue: 150/255, alpha: 1))
        colors.append(UIColor(red: 48/255, green: 63/255, blue: 159/255, alpha: 1))
        self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        
    }
}



