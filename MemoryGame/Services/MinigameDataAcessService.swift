//
//  MinigameDataAcessService.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/9/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import Foundation
import RealmSwift

class MinigameDataAcessService{
    
    static let sharedInstance = MinigameDataAcessService()
    
    func getAllMinigames() -> [MiniGame] {
        
        var minigames = [MiniGame]()
        
        do {
            let queriedMinigames = try Realm().objects(MiniGame.self)
            
            for minigame in queriedMinigames{
                minigames.append(minigame)
            }
            
        } catch let error as NSError {
            print ("Loading MiniGames was not possible \(error.userInfo)")
        }
        
        return minigames
    }
    
    
    func fetchMinigame (withName name: String)-> MiniGame{
        var minigame = MiniGame ()
        
        do {
            minigame = (try Realm().objects(MiniGame.self).filter("name == '\(name)'").first)!
        } catch let error as NSError {
            print ("Loading Minigames was not possible \(error.userInfo)")
        }
        
        return minigame
        
    }
    
    func getMinigameCategories(minigame: MiniGame) -> [Category]{
        var fetchedMinigame = self.fetchMinigame(withName: minigame.name)
        var categories = [Category]()
        
        for category in fetchedMinigame.categories{
            categories.append(category)
        }
        return categories
    }
    
    func updateCategories (categoryList: [Category], minigame: MiniGame){
        
        let realm = try! Realm()
        
        do {
            
            let fetchedMinigame = self.fetchMinigame(withName: minigame.name)
            
            try realm.write {
                fetchedMinigame.categories.removeAll()
                
                for category in categoryList{
                    fetchedMinigame.categories.append(category)
                }
            }
            
        } catch let error as NSError {
            print ("Loading Categories was not possible \(error.userInfo)")
        }
        
    }
    
}
