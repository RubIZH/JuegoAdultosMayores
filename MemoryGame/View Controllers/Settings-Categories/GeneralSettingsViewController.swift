//
//  GeneralSettingsViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/17/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit
import RealmSwift

class GeneralSettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var pickerView: UIPickerView!
    let pickerData = [ "4", "6", "12"]
    var selected = 4
    var settings = SettingsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.loadSettings()
        selected = settings.numberOfPicturesForDisplay
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let realm = try! Realm()
        
        do {
            
            try realm.write {
                settings.numberOfPicturesForDisplay = selected
            }
            
        } catch let error as NSError {
            print ("Loading Categories was not possible \(error.userInfo)")
        }
     
    }
    
    func loadSettings(){
        
        do {
            self.settings = (try Realm().objects(SettingsModel.self).first)!
            
        } catch let error as NSError {
            print ("Cannot load settings \(error.userInfo)")
        }
        
        switch settings.numberOfPicturesForDisplay{
        case 4: pickerView.selectRow(0, inComponent: 0, animated: true)
        case 6: pickerView.selectRow(1, inComponent: 0, animated: true)
        case 12: pickerView.selectRow(2, inComponent: 0, animated: true)
        default: print ("Loading options wasn't possible")
        }
        
    }
    
    //Mark: PickerViewDelegate
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selected = Int(pickerData[row])!
        
    }
    

    

}


