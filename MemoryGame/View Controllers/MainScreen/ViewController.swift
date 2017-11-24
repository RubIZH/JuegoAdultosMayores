//
//  ViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/16/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//


import UIKit
import RealmSwift
import UPCarouselFlowLayout


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let realm = try! Realm()

    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!

    fileprivate var currentPage: Int = 0
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.currentPage = 0
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {

        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let dataLoader = DataLoader()
            dataLoader.loadData()
        }
        
        
        
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
    }
    
    
    // MARK: - Card Collection Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true;
        
        switch indexPath.row{
            case 0: cell.tituloLabel.text = "¡Mismas Categorías!"
                    cell.descriptionTextView.text = "Debes seleccionar todas las imágenes de la categoría que se te indica para que puedas ganar"
                    break
            case 1:     cell.tituloLabel.text = "¡Forma Parejas!"
                    cell.descriptionTextView.text = "Deberás formar parejas de imágenes que corresponden a la misma categoría para que puedas ganar la partida"
                    break
            default: print("Error al seleccionar modo de juego")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0: goToGameCanvas(gameMode: 1);
        case 1: goToGameCanvas(gameMode: 2);
        default: print ("Error was produced while picking game mode")
        }

    }
    
    func goToGameCanvas(gameMode: Int ){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "gameCanvas") as! UINavigationController
        let canvasController = controller.viewControllers.first as! ImagesCollectionViewController
        canvasController.gameMode = gameMode
        self.present(controller, animated: true, completion: nil)
    }

    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }

}

