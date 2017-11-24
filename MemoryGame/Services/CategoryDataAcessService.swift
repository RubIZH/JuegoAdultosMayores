//
//  CategoryDataAcessService.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/5/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryDataAcessService {
    
    static let sharedInstance = CategoryDataAcessService()

    
    func getAllCategories() -> [Category] {
        
        var categories = [Category]()
        
        do {
            let queriedCategories = try Realm().objects(Category.self)
            
            for category in queriedCategories{
                categories.append(category)
            }
            
        } catch let error as NSError {
            print ("Loading Categories was not possible \(error.userInfo)")
        }
        
        return categories
        
    }
    
    func getCategory(withName name: String) -> [Category]{
        
        var categories = [Category]()
        
        do {
            let queriedCategories = try Realm().objects(Category.self).filter("name == '\(name)'")
            
            for category in queriedCategories{
                categories.append(category)
            }

        } catch let error as NSError {
            print ("Loading Categories was not possible \(error.userInfo)")
        }
        
        return categories
        
    }
    
    func updateName(category:Category, name: String){
        
        let realm = try! Realm()
        
        do {
            
            try realm.write {
                category.name = name
            }
            
        } catch let error as NSError {
            print ("Loading Categories was not possible \(error.userInfo)")
        }
        
    }
    
    func deleteCategory(category: Category){
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch let error as NSError {
            print ("Loading Categories was not possible \(error.userInfo)")
        }
        
    }
    
    func addCategory() -> Category{
        let newCategory = Category()
        
        newCategory.name = self.newCategoryName()
        newCategory.isDefault = false
       
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(newCategory)
            }
        } catch let error as NSError {
            print ("Loading Categories was not possible \(error.userInfo)")
        }
        
        return newCategory
    }
    
    
    func newCategoryName()-> String{
        
        
        do {
            
            var counter = 1
            while true{

                let queriedCategories = try Realm().objects(Category.self).filter("name == 'Sin Título \(counter)'")

                if queriedCategories.count == 0{
                    return "Sin Título \(counter)"
                }
                
                counter += 1
                
            }
            
        } catch let error as NSError {
            print ("Loading Categories was not possible \(error.userInfo)")
        }
        
        
        
        return ""
    }
    
    
    func deletePicture(picture: Picture){
        
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.delete(picture)
            }
        } catch let error as NSError {
            print ("Loading Pictures was not possible \(error.userInfo)")
        }
        
    }
    
    func addPicture(image: UIImage, toCategory category: Category){

        let newPicture = Picture()
        newPicture.canBeDeleted = true
        newPicture.pictureData = NSData(data: UIImageJPEGRepresentation(image, 0.7)!)
        
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add (newPicture)
                category.pictures.append(newPicture)
            }
        } catch let error as NSError {
            print ("Loading Pictures was not possible \(error.userInfo)")
        }
    }
    
}
