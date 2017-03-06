//
//  SunnyDayScene.swift
//  IntroSpriteKit
//
//  Created by Annie Tung on 3/6/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import SpriteKit

class SunnyDayScene: SKScene {
    
    let backgroundTexture: SKTexture = SKTexture(imageNamed: "bkgd_sunnyday")
    var backgroundNode: SKSpriteNode?
    let catStandingTexture: SKTexture = SKTexture(imageNamed: "moving_kitty_1")
    let catMovingTexture: SKTexture = SKTexture(imageNamed: "moving_kitty_2")
    var catNode: SKSpriteNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        print("Init")
        self.backgroundColor = .gray
        
        // initializing and setting the background node's texture
        self.backgroundNode = SKSpriteNode(texture: backgroundTexture)
        self.backgroundNode?.anchorPoint = self.anchorPoint
        
        self.catNode = SKSpriteNode(texture: catStandingTexture)
        self.catNode!.anchorPoint = self.backgroundNode!.anchorPoint
        self.catNode!.setScale(0.4)
        
        self.addChild(self.backgroundNode!)
        self.backgroundNode!.addChild(self.catNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        print("Did Move")
        
        let walkingAnimation = SKAction.animate(with: [catStandingTexture, catMovingTexture], timePerFrame: 0.5)
        let infiniteAnimation = SKAction.repeatForever(walkingAnimation)
        
        catNode?.run(infiniteAnimation)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // detect the first tap
        guard let validTouch = touches.first else { return }
        
        let moveAction = SKAction.move(to: validTouch.location(in: self), duration: 1.0)//SKScene inherits from SKNode
//        self.catNode?.run(moveAction)
        
        let catTwit = SKAction.playSoundFileNamed("cat_twit.wav", waitForCompletion: false)
//        self.catNode?.run(catTwit)
        
        let groupAction = SKAction.group([moveAction, catTwit])
        self.catNode?.run(groupAction)
    }
}
