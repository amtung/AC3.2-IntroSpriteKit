//
//  GameViewController.swift
//  IntroSpriteKit
//
//  Created by Louis Tur on 3/6/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            let sunnyScene: SunnyDayScene = SunnyDayScene(size: self.view.frame.size)
            view.presentScene(sunnyScene)
            
            /*// Load the SKScene from 'GameScene.sks'
             if let scene = SKScene(fileNamed: "GameScene") {
             
             // Set the scale mode to scale to fit the window
             scene.scaleMode = .aspectFill
             
             // Present the scene
             view.presentScene(scene)
             }*/
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
