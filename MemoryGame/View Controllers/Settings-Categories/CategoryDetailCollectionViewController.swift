//
//  CategoryDetailCollectionViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/6/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit
import SimpleImageViewer
import ALCameraViewController


class CategoryDetailCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var categoryDeleteButton: UIBarButtonItem!
    var category : Category!
    var currentPicture : Picture!

    @IBAction func categoryDeleteButtonTapped(_ sender: Any) {
        self.popDeleteAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category.name
        
        if category.isDefault{
            categoryDeleteButton.isEnabled = false
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.pictures.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as!  CategoryImageCollectionViewCell

        if indexPath.row > 0{
            let data = category.pictures[indexPath.row-1].pictureData
            cell.imageView.image = UIImage(data: data! as Data)
            cell.imageView.contentMode = .scaleAspectFill
        }else{
            cell.imageView.image = #imageLiteral(resourceName: "AddPictureIcon")
            cell.imageView.contentMode = .scaleAspectFill
        }



        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as!  CategoryImageCollectionViewCell
     
        if indexPath.row > 0{
            let configuration = ImageViewerConfiguration { config in
                config.imageView = cell.imageView
            }
            let imageViewerController = ImageViewerController(configuration: configuration)
            
            if(category.pictures[indexPath.row-1].canBeDeleted){ //Doesn't allow a picture to be deleted if it is marked
                let toolbar = setupDeleteToolbar()
                imageViewerController.view.addSubview(toolbar)
                currentPicture = category.pictures[indexPath.row-1]
            }
            present(imageViewerController, animated: true)
        }else{
            self.openLibrary()

        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderCollectionReusableView
        headerView.tfName.text = category.name
        headerView.setup()
        headerView.delegate = self
        
        if category.isDefault{
            headerView.tfName.isEnabled = false
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / 3 - 8
        return CGSize(width: cellWidth, height: cellWidth)
        
    }
    
 
    
    

}

//Mark: Delete Category Action
extension CategoryDetailCollectionViewController{
    
    func popDeleteAlert(){
        let alert = UIAlertController(title: "Eliminar", message: "¿Deseas eliminar esta categoría", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Eliminar", style: UIAlertActionStyle.destructive, handler: {action in self.deleteCategory()}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteCategory(){
        CategoryDataAcessService.sharedInstance.deleteCategory(category: self.category)
        navigationController?.popViewController(animated: true)
    }
    
}

//Mark: SaveCategoryData Protocol
extension CategoryDetailCollectionViewController: SaveCategoryData{
    func saveName(name: String) {
        self.title = name
        CategoryDataAcessService.sharedInstance.updateName(category: self.category, name: name)
    }
}

//Mark: Library Picture Selection
extension CategoryDetailCollectionViewController{
    
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: true, allowResizing: false, allowMoving: false, minimumSize: CGSize(width: 60, height: 60))
    }
    
    func openLibrary() {
        let libraryViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] image, asset in
            if let img = image{
                CategoryDataAcessService.sharedInstance.addPicture(image: img, toCategory: (self?.category)!)
                self?.collectionView?.reloadData()
            }
            self?.dismiss(animated: true, completion: nil)

        }
        
        present(libraryViewController, animated: true, completion: nil)
    }
    
    
}

//Mark: Delete Picture Action
extension CategoryDetailCollectionViewController{
    private func setupDeleteToolbar () -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y:  UIScreen.main.bounds.height-46, width: self.view.frame.size.width, height: 46)
        toolbar.sizeToFit()
        toolbar.barStyle = UIBarStyle.blackTranslucent
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action:#selector(CategoryDetailCollectionViewController.deleteButtonWasTapped))
        trashButton.tintColor = UIColor.white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([flexSpace,trashButton,flexSpace], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
    
    @objc internal func deleteButtonWasTapped(){
        let alert = UIAlertController(title: "Eliminar", message: "¿Deseas eliminar esta imagen?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Eliminar", style: UIAlertActionStyle.destructive, handler: {action in self.deletePicture()}))
        self.presentedViewController?.present(alert, animated: true, completion: nil)
    }
    
    func deletePicture(){
        CategoryDataAcessService.sharedInstance.deletePicture(picture: currentPicture)
        currentPicture = nil
        collectionView?.reloadData()
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        
        self.presentedViewController?.view.window?.layer.add(transition, forKey: "dismissal")

        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}



