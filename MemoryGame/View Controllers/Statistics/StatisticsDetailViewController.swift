//
//  StatisticsDetailViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/24/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

class StatisticsDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var totalGamesLabel: UILabel!
    @IBOutlet weak var totalGameTimeLabel: UILabel!
    @IBOutlet weak var averageTimeLabel: UILabel!
    var minigame = MiniGame()
    
    override func viewDidLoad() {
        scrollView.contentSize = containerView.frame.size
        super.viewDidLoad()
        
        totalGamesLabel.text = "\(minigame.numberOfGames)"
        totalGameTimeLabel.text = timeString(time: TimeInterval(minigame.playTime))
        
        if(minigame.numberOfGames > 0){
            let average : Int = minigame.playTime / minigame.numberOfGames
            averageTimeLabel.text = timeString(time: TimeInterval(average) )
        }else{
            averageTimeLabel.text = timeString(time: TimeInterval(0) )
        }
        
        
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
    
    private func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    
}

