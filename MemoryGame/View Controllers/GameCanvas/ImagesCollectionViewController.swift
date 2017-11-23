//
//  ImagesCollectionViewController.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 10/22/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit
import PeekPop
import RealmSwift
import PopupDialog



private let reuseIdentifier = "ImageCollectionViewCell"

class ImagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var peekPop: PeekPop?
    var previewingContext: PreviewingContext?
    var answers = [Answer]()
    var gameMode = 2
    var cellSize : CGFloat = 0.0
    
    @IBAction func pauseButton(_ sender: Any) {
        self.showPauseDialog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        peekPop = PeekPop(viewController: self)
        previewingContext = peekPop?.registerForPreviewingWithDelegate(self, sourceView: collectionView!)
        self.loadGame()
        
        self.setupNavigationBar()
    }
    
    // MARK: UICollectionView DataSource and Delegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.image = answers[indexPath.item].image
            imageCell.answer = answers[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            
            
            switch gameMode{
            case 1: Minigame_Mode1.sharedInstance.imageBehaviour(cell: imageCell)
            case 2: Minigame_Mode2.sharedInstance.imageBehaviour(cell: imageCell)
            default: print ("There was a problem when registering cell")
            }
            
        }
        
        self.monitorGameState()
    }
    
}

extension ImagesCollectionViewController: PeekPopPreviewingDelegate {
    
    
    func setConstraints(_ picturesAcross : Int){
        
        cellSize = (self.view.bounds.size.width)/CGFloat(picturesAcross) * 0.75
        let totalCellWidth = cellSize * CGFloat (picturesAcross)
        let sideMarginSize = (self.view.bounds.size.width - totalCellWidth) / 2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: self.view.bounds.size.width * 0.25,
                                           left: sideMarginSize-10,
                                           bottom: 0,
                                           right: sideMarginSize-10)
        
        collectionView!.collectionViewLayout = layout
    }
    
    
    private func loadGame (){
        
        var setup = 0
        switch gameMode{
            case 1:
                Minigame_Mode1.sharedInstance.loadMinigame(name: "¡Mismas Categorias!")
                answers = Minigame_Mode1.sharedInstance.answers
                setup = Minigame_Mode1.sharedInstance.settings.obtainSetup()
                self.navigationItem.prompt = Minigame_Mode1.sharedInstance.promptInstructions
                self.title = Minigame_Mode1.sharedInstance.title
                break
            case 2:
                Minigame_Mode2.sharedInstance.loadMinigame(name: "¡Forma Parejas!")
                answers = Minigame_Mode2.sharedInstance.answers
                setup = Minigame_Mode2.sharedInstance.settings.obtainSetup()
                self.navigationItem.prompt = Minigame_Mode2.sharedInstance.promptInstructions
                self.title = Minigame_Mode2.sharedInstance.title
                break
            default: print ("Loading Games Was not Possible")
        }
        
        if(cellSize == 0.0){
            setConstraints(setup)
        }


    }
    
    private func reloadGame(){
        self.answers.removeAll()
        self.loadGame()
        self.collectionView?.performBatchUpdates(
            {
                self.collectionView?.reloadSections(NSIndexSet(index: 0) as IndexSet)
        }, completion: { (finished:Bool) -> Void in
        })
    }
    
    func monitorGameState(){
        
        switch gameMode{
        case 1: if Minigame_Mode1.sharedInstance.hasWon {showStandardDialog()}
        case 2: if Minigame_Mode2.sharedInstance.hasWon {showStandardDialog()}
        default: print ("Loading winning conditions was not possible")
        }

    }
    
    func showStandardDialog(animated: Bool = true) {
        let title = "¡Éxito, completaste la partida!"
        let message = "¿Deseas continuar?"
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .vertical, transitionStyle: .zoomIn, gestureDismissal: false) {
        }
        let buttonOne = CancelButton(title: "Salir") {
            self.exit()
        }
        let buttonTwo = DefaultButton(title: "Continuar") {
            self.reloadGame()
        }
        popup.addButtons([buttonTwo, buttonOne])
        
        self.present(popup, animated: animated, completion: nil)
    }
    
    func showPauseDialog(animated: Bool = true) {
        let title = "¡Pausa!"
        let message = "¿Deseas continuar?"
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .vertical, transitionStyle: .bounceDown, gestureDismissal: true) {
        }
        let buttonOne = CancelButton(title: "Salir") {
            self.exit()
        }
        let buttonTwo = DefaultButton(title: "Continuar") {
        }
        popup.addButtons([buttonOne, buttonTwo])
        
        self.present(popup, animated: animated, completion: nil)
    }
    
    private func exit(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "mainScreen") as! UITabBarController
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    private func setupNavigationBar(){
        let backItem = UIBarButtonItem()
        backItem.title = "Regresar"
        navigationItem.backBarButtonItem = backItem
        
        var colors = [UIColor]()
        colors.append(UIColor(red: 88/255, green: 0/255, blue: 150/255, alpha: 1))
        colors.append(UIColor(red: 48/255, green: 63/255, blue: 159/255, alpha: 1))
        self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        
    }
    
    //MARK: PeekPopPreviewingDelegate Implementation
    func previewingContext(_ previewingContext: PreviewingContext, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        if let previewViewController = storyboard.instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController {
            if let indexPath = collectionView!.indexPathForItem(at: location) {
                let selectedImage = answers[indexPath.item].image
                if let layoutAttributes = collectionView!.layoutAttributesForItem(at: indexPath) {
                    previewingContext.sourceRect = layoutAttributes.frame
                }
                previewViewController.image = selectedImage
                return previewViewController
            }
            
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: PreviewingContext, commitViewController viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
}



