//
//  HeaderCollectionReusableView.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/6/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

protocol SaveCategoryData{
    func saveName(name: String)
}

class HeaderCollectionReusableView: UICollectionReusableView, UITextFieldDelegate {
    @IBOutlet weak var tfName: UITextField!
    var storedName = " "
    var delegate : SaveCategoryData!
    
    func setup(){
        tfName.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        storedName = tfName.text!
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        if let text = tfName.text, !text.isEmpty{
            
            if tfName.text != storedName{
                
                if !nameRepeats(name: tfName.text!){
                    delegate.saveName(name: tfName.text!)
                }else{
                    showAlert(message: "Favor de seleccionar un nombre único")
                    restoreName()
                }
            }
            
        }else{
            showAlert(message: "La categoría debe tener un nombre")
            restoreName()
        }
    }
    
    func restoreName(){
        tfName.text = storedName
        storedName = ""
    }
    
    func nameRepeats(name: String) -> Bool{
        
        let categories = CategoryDataAcessService.sharedInstance.getCategory(withName: name)

        if categories.count > 0{
            return true
        }else{
            return false
        }

    }
    
    
    func showAlert(message: String){
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }


    
    
    
    
}
