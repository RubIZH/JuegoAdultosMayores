//
//  CategoryTableViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/5/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categorías"
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

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories = CategoryDataAcessService.sharedInstance.getAllCategories()
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let currentCategory = categories[indexPath.row]
        
        cell.textLabel?.text = currentCategory.name

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if segue.identifier == "detail"{
            let view = segue.destination as! CategoryDetailCollectionViewController
            view.category = categories[(indexPath?.row)!]
        }else if segue.identifier == "add"{
            let newCategory = CategoryDataAcessService.sharedInstance.addCategory()
            let view = segue.destination as! CategoryDetailCollectionViewController
            view.category = newCategory
        }
    }

}
