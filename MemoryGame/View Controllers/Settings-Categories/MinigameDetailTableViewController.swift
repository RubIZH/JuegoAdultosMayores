//
//  MinigameDetailTableViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/11/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

class MinigameDetailTableViewController: UITableViewController {
    
    var selectedIndexPathArray = Array<IndexPath>()
    var minigame : MiniGame!
    var categories = [Category]()
    var categoriesInMinigame = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = minigame.name

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        MinigameDataAcessService.sharedInstance.updateCategories(categoryList: categoriesInMinigame, minigame: minigame)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        minigame = MinigameDataAcessService.sharedInstance.fetchMinigame(withName: minigame.name)
        categories = CategoryDataAcessService.sharedInstance.getAllCategories()
        categoriesInMinigame = MinigameDataAcessService.sharedInstance.getMinigameCategories(minigame: minigame)
        
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.accessoryType = .none
        for category in categoriesInMinigame{
            if categories[indexPath.row].name == category.name{
                cell.accessoryType = .checkmark
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        let selectedCategory = categories[indexPath.row]

        if cell?.accessoryType == .checkmark && !selectedCategory.isDefault{
            cell?.accessoryType = .none
            if let index = categoriesInMinigame.enumerated().filter( { $0.element.name == selectedCategory.name }).map({ $0.offset }).first {
                categoriesInMinigame.remove(at: index)
            }
            
        }else{
            categoriesInMinigame.append(selectedCategory)
            cell?.accessoryType = .checkmark
        }
       
    }
    


}
