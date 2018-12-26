//
//  GameScene.swift
//  swift-Game
//
//  Created by nsuhara on 2018/11/29.
//  Copyright © 2018 nsuhara. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var ballNode: SKSpriteNode!
    private var barNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        // Inisialize.
        let physicsBody = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        physicsBody.friction = 0.0
        
        self.ballNode = (self.childNode(withName: "ball") as! SKSpriteNode)
        self.barNode = (self.childNode(withName: "bar") as! SKSpriteNode)
        self.ballNode.physicsBody?.applyImpulse(CGVector(dx: 100.0, dy: 100.0))
        self.physicsBody = physicsBody
        self.physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        // Remove block.
        if nodeA.name == "block" {
            nodeA.removeFromParent()
        } else if nodeB.name == "block" {
            nodeB.removeFromParent()
        }
        
        // Set game over.
        if nodeA.name == "Scene" {
            if nodeB.position.y < self.barNode.position.y {
                gameOver(message: "Game Over!")
                return
            }
        } else if nodeB.name == "Scene" {
            if nodeA.position.y < self.barNode.position.y {
                gameOver(message: "Game Over!")
                return
            }
        }
        
        // Set clear.
        if self.childNode(withName: "block") == nil {
            gameOver(message: "Clear!")
            return
        }
    }
    
    private func gameOver(message: String) {
        // Stop ball.
        self.ballNode.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        
        // Clean screen.
        self.removeAllChildren()
        self.removeAllActions()
        self.scene?.removeFromParent()
        
        // Show the reason for game over.
        let gameoverNode = SKLabelNode()
        gameoverNode.position = CGPoint(x: 0.0, y: 0.0)
        gameoverNode.text = message
        gameoverNode.name = "label"
        gameoverNode.fontName = "Helvetica"
        gameoverNode.fontColor = .red
        gameoverNode.fontSize = 72
        self.addChild(gameoverNode)
        
        // Set restarting time.
        Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(self.callbackTimer),
            userInfo: nil,
            repeats: false)
    }
    
    @objc func callbackTimer() {
        //  Restart.
        if let view = self.view {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.barNode.position.x = t.location(in: self).x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.barNode.position.x = t.location(in: self).x
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
}
