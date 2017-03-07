//
//  SunnyDayScene.swift
//  IntroSpriteKit
//
//  Created by Annie Tung on 3/6/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import SpriteKit

struct SceneCategories {
    static let fish: UInt32 = 0x1 << 0 // 0 bit shift operation
    static let cat: UInt32 = 0x1 << 1 // 1
    static let dog: UInt32 = 0x1 << 2 // 2
    static let bird: UInt32 = 0x1 << 3 // 4
}

class SunnyDayScene: SKScene, SKPhysicsContactDelegate {
    
    let backgroundTexture: SKTexture = SKTexture(imageNamed: "bkgd_sunnyday")
    let catStandingTexture: SKTexture = SKTexture(imageNamed: "moving_kitty_1")
    let catMovingTexture: SKTexture = SKTexture(imageNamed: "moving_kitty_2")
    let fishTexture: SKTexture = SKTexture(imageNamed: "fish")
    let catTextureAtlas: SKTextureAtlas = SKTextureAtlas()
    
    var backgroundNode: SKSpriteNode?
    var catNode: SKSpriteNode?
    var fishNode: SKSpriteNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        print("Init")
        self.backgroundColor = .gray
        self.physicsWorld.contactDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        print("Did Move")
        
        // initializing and setting the background node's texture
        self.backgroundNode = SKSpriteNode(texture: backgroundTexture)
        self.backgroundNode?.anchorPoint = self.anchorPoint
        
        // cat texture atlas
        //        let catTextureAtlas: SKTextureAtlas = SKTextureAtlas(dictionary:
        //            ["cat1" : UIImage(named: "moving_kitty_1")!,
        //             "cat2" : UIImage(named: "moving_kitty_2")!])
        //        self.catNode = SKSpriteNode(texture: catTextureAtlas.textureNamed("cat1"))
        let catTextureAtlas: SKTextureAtlas = SKTextureAtlas(named: "moving_kitty")
        dump(catTextureAtlas.textureNames)
        let catStanding = catTextureAtlas.textureNamed("moving_kitty_1")
        let catMoving = catTextureAtlas.textureNamed("moving_kitty_2")
        
        self.catNode = SKSpriteNode(texture: catStanding)
        
        // fish here
        self.fishNode = SKSpriteNode(texture: fishTexture)
        self.fishNode?.zPosition = 99 // behind the cat
        self.fishNode?.setScale(0.2)
        self.fishNode?.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        
        let fishPhysics = SKPhysicsBody(texture: self.fishTexture, size: self.fishNode!.size)
        fishPhysics.collisionBitMask = SceneCategories.fish
        fishPhysics.contactTestBitMask = SceneCategories.fish
        self.fishNode?.physicsBody = fishPhysics
        self.fishNode?.physicsBody?.affectedByGravity = false //true
        
        //        self.catNode = SKSpriteNode(texture: catStandingTexture)
        // uncomment this to set anchorPoint back to the middle of the cursor:
        //        self.catNode!.anchorPoint = self.backgroundNode!.anchorPoint
        self.catNode!.setScale(0.2)
        self.catNode!.zPosition = 100 // moving towards us
        self.catNode!.position = CGPoint(x: self.frame.midX, y: self.frame.midY) // move the cat to the center
        
        self.addChild(self.backgroundNode!)
        self.backgroundNode!.addChild(self.catNode!)
        self.backgroundNode!.addChild(self.fishNode!)
        
        let walkingAnimation = SKAction.animate(with: [catStanding, catMoving], timePerFrame: 0.5)
        let infiniteAnimation = SKAction.repeatForever(walkingAnimation)
        
        catNode?.run(infiniteAnimation)
        
        //        let grassConstraints = SKConstraint.positionX(SKRange(lowerLimit: 0.0, upperLimit: self.frame.maxX), y: SKRange(lowerLimit: 0.0, upperLimit: 300.0)) // x,y on sprite starts at bottom left, this is an estimate of range here
        //        catNode?.constraints = [grassConstraints]
        
        let xRange = SKRange(lowerLimit: catNode!.size.width / 2, upperLimit: self.frame.maxX - (catNode!.size.width / 2))
        let yRange = SKRange(lowerLimit: catNode!.size.height / 2, upperLimit: 300 - (catNode!.size.height / 2))
        let grassConstraints = SKConstraint.positionX(xRange, y: yRange)
        catNode?.constraints = [grassConstraints]
        fishNode?.constraints = [grassConstraints]
        
        // physics
        let catPhysicsBody = SKPhysicsBody(texture: self.catNode!.texture!, size: self.catNode!.size)
        catPhysicsBody.collisionBitMask = SceneCategories.fish
        catPhysicsBody.contactTestBitMask = SceneCategories.fish
        catNode?.physicsBody = catPhysicsBody
        catNode!.physicsBody!.affectedByGravity = false // true
    }
    
    // MARK: - Contact Delegate 
    
    func didEnd(_ contact: SKPhysicsContact) {
        print("Did end touching")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // can check bodyA/B - direction,force,exact position at which they contacted
        print("Did begin touching")
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // detect the first tap
        guard let validTouch = touches.first else { return }
        
        let catXPosition = self.catNode!.position.x
        if catXPosition < validTouch.location(in: self).x {
            catNode?.xScale = fabs(catNode!.xScale) * -1.0 // fabs returns absolute value
        } else {
            catNode?.xScale = fabs(catNode!.xScale) * 1.0
        }
        
        let moveAction = SKAction.move(to: validTouch.location(in: self), duration: 1.0)//SKScene inherits from SKNode
        let catTwit = SKAction.playSoundFileNamed("cat_twit.wav", waitForCompletion: false)
        
        let groupAction = SKAction.group([moveAction, catTwit])
        self.catNode?.run(groupAction)
    }
}
