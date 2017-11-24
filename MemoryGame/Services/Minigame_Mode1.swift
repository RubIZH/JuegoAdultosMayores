//
//  Minigame_Mode1.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 10/24/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import Foundation
import RealmSwift
import AudioToolbox

class Minigame_Mode1{
    
    /*Game mode 1 consists on identifying several pictures of a given category
      that are mixed in with pictures of a second category
     
     This structc stores the rules for a given game mode, so it is easier to add new modes
     */
    static let sharedInstance = Minigame_Mode1()
    
    var currentMinigame : MiniGame!
    var answers = [Answer]()
    var numberOfCorrectAnswers = 0
    var currentCorrectAnswers = 0
    var settings : SettingsModel!
    var hasWon = false
    var promptInstructions = "Selecciona Imágenes con"
    var title = ""

    
    func updateGameStats(seconds: Int){
        let realm = try! Realm()
        
        do {
            
            try realm.write {
                currentMinigame.playTime += seconds
                currentMinigame.numberOfGames += 1
            }
            
        } catch let error as NSError {
            print ("Loading Minigame was not possible \(error.userInfo)")
        }
        
    }
    
    
    func clear(){
        currentMinigame = MiniGame()
        answers.removeAll()
        numberOfCorrectAnswers = 0
        currentCorrectAnswers = 0
        settings = SettingsModel()
        hasWon = false
    }
    
    func loadMinigame(name: String){
        self.clear()
        currentMinigame = MinigameDataAcessService.sharedInstance.fetchMinigame(withName: name)
        self.loadSettings()
        let categories = self.pickCategories()

        self.setNumberOfCorrectAnswers(categories)
    }
    
    func addCorrectAnswer(){
        
        currentCorrectAnswers += 1
        
        if (currentCorrectAnswers == numberOfCorrectAnswers){
            self.hasWon = true
        }
        
    }
    
    //This defines how a cell should behave when tapped
    func imageBehaviour(cell: ImageCollectionViewCell){
        
        if cell.answer.isSelected == false{
            if (cell.answer.isCorrect){
                cell.answer.isSelected = true
                cell.imageView.image = cell.answer.imageCorrect
                cell.press()
                self.addCorrectAnswer()
                AudioServicesPlaySystemSound(1520)
            }else{
                cell.shake()
                AudioServicesPlaySystemSound(1521)
            }
        }
        
    }

    private func pickCategories() -> [Category]{
        let categories = MinigameDataAcessService.sharedInstance.getMinigameCategories(minigame: currentMinigame)
        let eligibleCategories = categories.filter({$0.pictures.count >= 6})
        
        var selectedCategories = [Category]()
        var possibleValues = [Int](0...eligibleCategories.count-1)
        
        
        for _ in 0 ... 1{
            let randomValue = self.generateRandomNumber(number: possibleValues.count)
            let index = possibleValues[randomValue]
            possibleValues.remove(at: randomValue)
            selectedCategories.append(eligibleCategories[index])
        }
        return selectedCategories
    }
    

    
    private func setNumberOfCorrectAnswers(_ categories : [Category]){
        numberOfCorrectAnswers = 0
        var numberOfIncorrectAnswers = 0
        
        if (settings.numberOfPicturesForDisplay == 12)
        {
            numberOfCorrectAnswers = 6
            numberOfIncorrectAnswers = 6
        }else{
            repeat{
                numberOfCorrectAnswers = self.generateRandomNumber(number: settings.numberOfPicturesForDisplay)
                numberOfIncorrectAnswers = settings.numberOfPicturesForDisplay - numberOfCorrectAnswers
            } while numberOfCorrectAnswers <= 1
        }
        self.answers = self.generateAnswers(categories: categories, numberOfCorrectAnswers: numberOfCorrectAnswers, numberOfIncorrectAnswers: numberOfIncorrectAnswers)
    }
    

    
    func generateAnswers(categories: [Category], numberOfCorrectAnswers: Int, numberOfIncorrectAnswers: Int) -> [Answer]{

        let correctAnswers = generateCorrectAnwers(category: categories[0], numberOfCorrectAnswers: numberOfCorrectAnswers)
        self.title = categories[0].name //Sets title for instructions
        let incorrectAnswers = generateIncorrectAnswers(category: categories[1], numberOfIncorrectAnswers: numberOfIncorrectAnswers)

        return self.shuffleAnswers(correctAnswers: correctAnswers, incorrectAnswers: incorrectAnswers)

    }
    
    
    private func shuffleAnswers(correctAnswers: [Answer], incorrectAnswers: [Answer]) -> [Answer]{
        
        var shuffledAnswers =  incorrectAnswers + correctAnswers
        
        for _ in 0...10{
        shuffledAnswers.shuffle()
        }
        
        return shuffledAnswers
    }
    
    private func generateCorrectAnwers(category: Category, numberOfCorrectAnswers: Int) -> [Answer]{
        
        var pictures = self.toPictureArray(pictureList: category.pictures)
        var answers = [Answer]()
        
       
        for _ in 0 ..< numberOfCorrectAnswers {
            
            let randomIndex = self.generateRandomNumber(number: pictures.count )//Randomly picks a picture de include
            
            
            
            let picture = UIImage(data: pictures[randomIndex].pictureData! as Data ,scale: 1.0 )
            let answer = Answer(image: picture!, isCorrect: true)
            answers.append(answer)
            
            pictures.remove(at: randomIndex)//Removes a picture so it won't repeat itself
        }

        return answers

    }
    
    private func generateIncorrectAnswers(category: Category, numberOfIncorrectAnswers: Int) -> [Answer] {
        
        var pictures = self.toPictureArray(pictureList: category.pictures)
        var answers = [Answer]()
        
        
        for _ in 0 ..< numberOfIncorrectAnswers {
            
            let randomIndex = self.generateRandomNumber(number: pictures.count )//Randomly picks a picture de include
            
            let picture = UIImage(data: pictures[randomIndex].pictureData! as Data ,scale: 1.0 )
            let answer = Answer(image: picture!, isCorrect: false)
            answers.append(answer)
            
            pictures.remove(at: randomIndex)//Removes a picture so it won't repeat itself
        }
        
        return answers
    }
    
    private func loadSettings(){
        do {
            settings = try Realm().objects(SettingsModel.self).first
        } catch let error as NSError {
            print ("Cannot load settings \(error.userInfo)")
        }
    }
    
    
    private func toPictureArray(pictureList: List <Picture>) -> [Picture]{
        
        var pictureArray = [Picture]()
        
        for index in 0 ..< pictureList.count {
            
            pictureArray.append(pictureList[index])
            
        }
    
        return pictureArray
    }
    
    private func generateRandomNumber(number: Int) -> Int{
        return Int(arc4random_uniform(UInt32(number)))
    }
    

    
}
