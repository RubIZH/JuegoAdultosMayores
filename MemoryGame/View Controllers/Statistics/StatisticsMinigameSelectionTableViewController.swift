//
//  StatisticsMinigameSelectionTableViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/24/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

class StatisticsMinigameSelectionTableViewController: UITableViewController {
    
    var minigames = [MiniGame]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Estadísticas"
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
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        var colors = [UIColor]()
        colors.append(UIColor(red: 88/255, green: 0/255, blue: 150/255, alpha: 1))
        colors.append(UIColor(red: 48/255, green: 63/255, blue: 159/255, alpha: 1))
        self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        minigames = MinigameDataAcessService.sharedInstance.getAllMinigames()
        return minigames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currenMinigame = minigames[indexPath.row]
        cell.textLabel?.text = currenMinigame.name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if segue.identifier == "detail"{
            let view = segue.destination as! StatisticsDetailViewController
            view.minigame = minigames[(indexPath?.row)!]
        }
    }
    
    
    
}

