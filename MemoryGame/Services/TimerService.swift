//
//  TimerService.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/23/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import Foundation

class TimerService{
    
    static let sharedInstance = TimerService()
    var timer = Timer()
    var timerCounter = 0 //In seconds
    
    func resetTimer(){
        timerCounter = 0
         self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func startTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer(){
        timerCounter += 1
    }
    
    func stopTimer(){
        self.timer.invalidate()
    }
    
    func timeString() -> String {
        let time = TimeInterval(timerCounter)
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    
    
}
