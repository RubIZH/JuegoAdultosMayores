//
//  GameMasterService.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 10/23/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import Foundation
import RealmSwift

class GameMasterService {
    
    static let sharedInstance = GameMasterService()
    
    var currentMiniGame = MiniGame()
    var currentCategories = [Category]()
    var answers = [Answer]()
    var numberOfCorrectAnswers = 0
    var numberOfPicturesForDisplay = 0
    var picturesAcross = 0
    var correctAnswerCounter = 0
    var hasWon = false
    
    private init (){} //Can't instantiate because this is a singleton
    
    
    func setCurrentMiniGame(miniGameName: String){
        do {
            let miniGameQuery = try Realm().objects(MiniGame.self).filter("name == '\(miniGameName)'")
            self.currentMiniGame = miniGameQuery[0]
            self.numberOfPicturesForDisplay = 6
        } catch let error as NSError {
            print ("Loading Minigame was not possible \(error.userInfo)")
        }
    }
    
    func clear(){
        
        self.currentMiniGame = MiniGame()
        self.currentCategories.removeAll()
        self.answers.removeAll()
        self.numberOfCorrectAnswers = 0
        self.numberOfPicturesForDisplay = 0
        self.picturesAcross = 0
        self.correctAnswerCounter = 0
        hasWon = false
        
    }
    
    func setCurrentCategories() {
        let categoryList = currentMiniGame.categories
        
        var randomIndex1 = -1
        var randomIndex2 = -1
        
        repeat{
            randomIndex1 = generateRandomIndex(number: categoryList.count)
            randomIndex2 = generateRandomIndex(number: categoryList.count)
        }while randomIndex1 == randomIndex2
        
        currentCategories.append(categoryList[randomIndex1])
        currentCategories.append(categoryList[randomIndex2])
        self.obtainSetup()
    }
    
    func registerCategories(){
        
        numberOfCorrectAnswers = 0
        var numberOfIncorrectAnswers = 0
        
        if (numberOfPicturesForDisplay == 12)
        {
            numberOfCorrectAnswers = 6
            numberOfIncorrectAnswers = 6
        }else{
            repeat{
                numberOfCorrectAnswers = self.generateRandomIndex(number: numberOfPicturesForDisplay)
                numberOfIncorrectAnswers = numberOfPicturesForDisplay - numberOfCorrectAnswers
            } while numberOfCorrectAnswers <= 1
        }
        self.answers = Minigame_Mode1.sharedInstance.generateAnswers(categories: self.currentCategories, numberOfCorrectAnswers: numberOfCorrectAnswers, numberOfIncorrectAnswers: numberOfIncorrectAnswers)
    }
    
    
    func addCorrecAnswer(){
        self.correctAnswerCounter += 1
        
        if self.correctAnswerCounter == self.numberOfCorrectAnswers{
            self.hasWon = true
        }
    }
    
    private func obtainSetup(){
        
        switch numberOfPicturesForDisplay {
            
        case 4, 6 : picturesAcross = 2
        case 12  : picturesAcross = 3
        default: picturesAcross = 0
            
        }
        
    }
    
    private func generateRandomIndex(number: Int) -> Int{
        return Int(arc4random_uniform(UInt32(number)))
    }
    
    
    
    
    
    
}

