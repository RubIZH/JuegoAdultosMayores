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
    @IBAction func exitButton(_ sender: Any) {
        
        let title = "¿Deseas salir?"
        let popup = PopupDialog(title: title, message: nil, buttonAlignment: .vertical, transitionStyle: .bounceDown, gestureDismissal: true) {
        }
        let buttonOne = CancelButton(title: "Salir") {
            self.exit()
        }
        let buttonTwo = DefaultButton(title: "Continuar") {
        }
        popup.addButtons([buttonOne, buttonTwo])
        
        self.present(popup, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        peekPop = PeekPop(viewController: self)
        previewingContext = peekPop?.registerForPreviewingWithDelegate(self, sourceView: collectionView!)
        self.loadGame()
        
        self.setupNavigationBar()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
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
        
        var numberOfPicturesForDisplay = 0
        
        switch gameMode{
            case 1: numberOfPicturesForDisplay = Minigame_Mode1.sharedInstance.settings.numberOfPicturesForDisplay
                break
            case 2: numberOfPicturesForDisplay = Minigame_Mode2.sharedInstance.settings.numberOfPicturesForDisplay
                break
            default: print("Loading settings wasn't possible")
        }
        
        var totalCellHeight : CGFloat = 0
        
        switch numberOfPicturesForDisplay{
            case 4: totalCellHeight = cellSize * 2
            case 6: totalCellHeight = cellSize * 3
            case 12: totalCellHeight = cellSize * 4
            default: print("Loading settings wasn't possible")
        }
        
        let viewHeight = self.view.bounds.size.height - (UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height)
        
        let offsetTop = (viewHeight - totalCellHeight) / 2

        
        layout.sectionInset = UIEdgeInsets(top: offsetTop * 0.85,
                                           left: sideMarginSize-10,
                                           bottom: 0,
                                           right: sideMarginSize-10)
        
        collectionView!.collectionViewLayout = layout
    }
    

    private func loadGame (){
        TimerService.sharedInstance.resetTimer()
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
        case 1: if Minigame_Mode1.sharedInstance.hasWon {
            showStandardDialog()
            Minigame_Mode1.sharedInstance.updateGameStats(seconds: TimerService.sharedInstance.timerCounter)
            }
        case 2: if Minigame_Mode2.sharedInstance.hasWon {
            showStandardDialog()
            Minigame_Mode2.sharedInstance.updateGameStats(seconds: TimerService.sharedInstance.timerCounter)
            }
        default: print ("Loading winning conditions was not possible")
        }

    }
    
    func showStandardDialog(animated: Bool = true) {
        TimerService.sharedInstance.stopTimer()
        let title = "¡Éxito, completaste la partida!"
        let message = "¿Deseas continuar?\nTiempo: \(TimerService.sharedInstance.timeString())"
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
        TimerService.sharedInstance.stopTimer()
        let title = "¡Pausa!"
        let message = "¿Deseas continuar?\nTiempo: \(TimerService.sharedInstance.timeString())"
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .vertical, transitionStyle: .bounceDown, gestureDismissal: true) {
        }
        let buttonOne = CancelButton(title: "Salir") {
            self.exit()
        }
        let buttonTwo = DefaultButton(title: "Continuar") {
            TimerService.sharedInstance.startTimer()
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



