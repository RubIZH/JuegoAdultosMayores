//
//  DataLoader.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/17/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import Foundation
import RealmSwift

class DataLoader{
    
    let realm = try! Realm()
    
    func loadData(){
        
        print("Loading Data")
        let category1 = Category()
        let category2 = Category()
        let category3 = Category()
        let category4 = Category()
        let category5 = Category()
        let category6 = Category()
        
        category1.isDefault = true
        category2.isDefault = true
        category3.isDefault = true
        category4.isDefault = true
        category5.isDefault = true
        category6.isDefault = true
        
        category1.name = "Animales"
        category2.name = "Arte"
        category3.name = "Banderas"
        category4.name = "Sitios Históricos"
        category5.name = "Paisajes"
        category6.name = "Platillos"
        
        for index in 1 ... 16{
            
            let picture = Picture()
            picture.canBeDeleted = false
            let data = NSData(data: UIImageJPEGRepresentation(UIImage(named:"animales\(index).jpg" )!, 0.7)!)
            picture.pictureData = data
            
            category1.pictures.append(picture)
            
            try! realm.write{
                realm.add(picture)
            }
            
        }
        
        for index in 1 ... 11{
            
            let picture = Picture()
            picture.canBeDeleted = false
            let data = NSData(data: UIImageJPEGRepresentation(UIImage(named:"art\(index).jpg" )!, 0.7)!)
            picture.pictureData = data
            
            category2.pictures.append(picture)
            
            try! realm.write{
                realm.add(picture)
            }
            
        }
        
        for index in 1 ... 16{
            
            let picture = Picture()
            picture.canBeDeleted = false
            let data = NSData(data: UIImageJPEGRepresentation(UIImage(named:"banderas\(index).jpg" )!, 0.7)!)
            picture.pictureData = data
            
            category3.pictures.append(picture)
            
            try! realm.write{
                realm.add(picture)
            }
            
        }
        
        for index in 1 ... 16{
            
            let picture = Picture()
            picture.canBeDeleted = false
            let data = NSData(data: UIImageJPEGRepresentation(UIImage(named:"historicos\(index).jpg" )!, 0.7)!)
            picture.pictureData = data
            
            category4.pictures.append(picture)
            
            try! realm.write{
                realm.add(picture)
            }
            
        }
        
        for index in 1 ... 16{
            
            let picture = Picture()
            picture.canBeDeleted = false
            let data = NSData(data: UIImageJPEGRepresentation(UIImage(named:"paisaje\(index).jpg" )!, 0.7)!)
            picture.pictureData = data
            
            category5.pictures.append(picture)
            
            try! realm.write{
                realm.add(picture)
            }
            
        }
        
        for index in 1 ... 16{
            
            let picture = Picture()
            picture.canBeDeleted = false
            let data = NSData(data: UIImageJPEGRepresentation(UIImage(named:"platillo\(index).jpg" )!, 0.7)!)
            picture.pictureData = data
            
            category6.pictures.append(picture)
            
            try! realm.write{
                realm.add(picture)
            }
            
        }
        
        try! realm.write{
            realm.add(category1)
            realm.add(category2)
            realm.add(category3)
            realm.add(category4)
            realm.add(category5)
            realm.add(category6)
            
        }
        
        let minigame1 = MiniGame()
        minigame1.name = "¡Mismas Categorias!"
        minigame1.categories.append(category1)
        minigame1.categories.append(category2)
        minigame1.categories.append(category3)
        minigame1.categories.append(category4)
        minigame1.categories.append(category5)
        minigame1.categories.append(category6)
        
        let minigame2 = MiniGame()
        minigame2.name = "¡Forma Parejas!"
        minigame2.categories.append(category1)
        minigame2.categories.append(category2)
        minigame2.categories.append(category3)
        minigame2.categories.append(category4)
        minigame2.categories.append(category5)
        minigame2.categories.append(category6)
        
        try! realm.write{
            realm.add(minigame1)
            realm.add(minigame2)
        }
        
        let settings = SettingsModel()
        settings.numberOfPicturesForDisplay = 4
        try! realm.write{
            realm.add(settings)
        }
        
    }
    
    
}
