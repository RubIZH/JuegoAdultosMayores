//
//  MiniGamesTableViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/9/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

class MiniGamesTableViewController: UITableViewController {
    
    
    var minigames = [MiniGame]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Minijuegos"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let view = segue.destination as! MinigameDetailTableViewController
            view.minigame = minigames[(indexPath?.row)!]
        }
    }


}
