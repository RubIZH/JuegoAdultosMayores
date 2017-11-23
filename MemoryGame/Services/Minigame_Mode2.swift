//
//  Minigame_Mode2.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/15/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import Foundation
import RealmSwift
import AudioToolbox

class Minigame_Mode2 {
    
    static let sharedInstance = Minigame_Mode2()
    
    var currentMinigame : MiniGame!
    var settings: SettingsModel!
    var categories = [Category]()
    var answers = [Answer]()
    var currentlySelectedCell : ImageCollectionViewCell? = nil
    var numberOfCorrectAnswers = 0
    var hasWon = false
    let promptInstructions = "Selecciona parejas que correspondan a la misma"
    let title = "Categoría"
    
    
    

    func clear (){
        currentMinigame = nil
        settings = nil
        categories = [Category]()
        answers = [Answer]()
        currentlySelectedCell = nil
        numberOfCorrectAnswers = 0
        hasWon = false
    }
    func loadMinigame(name: String){
        
        self.clear()
        currentMinigame = MinigameDataAcessService.sharedInstance.fetchMinigame(withName: name)
        self.loadSettings()
        let categories = self.pickCategories()
        pickAnswers(categories)
    }
    
    func imageBehaviour(cell: ImageCollectionViewCell){
        
        if !cell.answer.isCorrect{
            AudioServicesPlaySystemSound(1520)
            if currentlySelectedCell == nil{
                DispatchQueue.main.async {
                    cell.pulsate()
                }
                cell.imageView.layer.borderColor = UIColor(red: 68/255, green: 39/255, blue: 160/255, alpha: 1).cgColor
                cell.imageView.layer.borderWidth = 4
                currentlySelectedCell = cell
            }else{
                if cell.answer.category.name == currentlySelectedCell?.answer.category.name && cell != currentlySelectedCell{
                    self.numberOfCorrectAnswers += 1
                
                    currentlySelectedCell?.layer.removeAllAnimations()
                    currentlySelectedCell?.imageView.layer.borderWidth = 0
                    
                    currentlySelectedCell?.answer.isCorrect = true
                    currentlySelectedCell?.imageView.image = currentlySelectedCell?.answer.imageCorrect
                    
                    cell.imageView.image = cell.answer.imageCorrect
                    cell.answer.isCorrect = true
                    
                    DispatchQueue.main.async {
                        cell.press()
                        AudioServicesPlaySystemSound(1520)
                    }
                    DispatchQueue.main.async {
                        self.currentlySelectedCell?.press()
                    }
                    currentlySelectedCell = nil
                }else{
                    self.currentlySelectedCell?.press()
                    AudioServicesPlaySystemSound(1520)
                    currentlySelectedCell?.layer.removeAllAnimations()
                    currentlySelectedCell?.imageView.layer.borderWidth = 0
                    currentlySelectedCell = nil
                }
            }
        }

        if numberOfCorrectAnswers == settings.numberOfPicturesForDisplay/2{
            hasWon = true
        }
        
    }
    
    func pickAnswers(_ categories: [Category]){
        
        for index in 0 ..< categories.count{
            self.answersFromCategory(categories[index])
        }
        
        for _ in 0 ... 10{
            self.answers.shuffle()
        }

    }
    
    private func answersFromCategory(_ category: Category){

        var possibleValues = [Int](0...category.pictures.count-1)
        

        for _ in 0 ... 1{
            let randomValue = self.generateRandomNumber(number: possibleValues.count)
            let index = possibleValues[randomValue]
            possibleValues.remove(at: randomValue)
            let pictureData = category.pictures[index].pictureData
            
            var answer = Answer(image: UIImage(data: pictureData! as Data)!, isCorrect: false)
            answer.category = category
            answers.append(answer)
        }
    }
    
    func loadSettings(){
        do {
            settings = try Realm().objects(SettingsModel.self).first
        } catch let error as NSError {
            print ("Cannot load settings \(error.userInfo)")
        }
    }
    
    private func pickCategories() -> [Category]{
        let categories = MinigameDataAcessService.sharedInstance.getMinigameCategories(minigame: currentMinigame)
        let eligibleCategories = categories.filter({$0.pictures.count > 2})
        
        var selectedCategories = [Category]()
        var possibleValues = [Int](0...eligibleCategories.count-1)

        
        for _ in 0 ..< settings.numberOfPicturesForDisplay/2{
            let randomValue = self.generateRandomNumber(number: possibleValues.count)
            let index = possibleValues[randomValue]
            possibleValues.remove(at: randomValue)
            selectedCategories.append(eligibleCategories[index])
        }
        return selectedCategories
    }
    
    private func generateRandomNumber(number: Int) -> Int{
        return Int(arc4random_uniform(UInt32(number)))
    }
    
}
