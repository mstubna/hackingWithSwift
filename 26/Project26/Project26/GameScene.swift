//
//  GameScene.swift
//  Project26
//
//  Created by Mike Stubna on 3/14/16.
//  Copyright (c) 2016 Mike. All rights reserved.
//

import SpriteKit
import CoreMotion

enum CollisionTypes: UInt32 {
    case Player = 1
    case Wall = 2
    case Star = 4
    case Vortex = 8
    case Finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!
    var gameOver = false

    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMoveToView(view: SKView) {
        loadBackground()
        loadLevel()
        createPlayer()
        createScoreLabel()

        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }

    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node == player {
            playerCollidedWithNode(contact.bodyB.node!)
        } else if contact.bodyB.node == player {
            playerCollidedWithNode(contact.bodyA.node!)
        }
    }

    func playerCollidedWithNode(node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody!.dynamic = false
            gameOver = true
            score -= 1

            let move = SKAction.moveTo(node.position, duration: 0.25)
            let scale = SKAction.scaleTo(0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])

            player.runAction(sequence) { [unowned self] in
                self.createPlayer()
                self.gameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            // next level?
        }
    }

    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.linearDamping = 0.5
        player.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
        player.physicsBody!.contactTestBitMask = CollisionTypes.Star.rawValue |
            CollisionTypes.Vortex.rawValue | CollisionTypes.Finish.rawValue
        player.physicsBody!.collisionBitMask = CollisionTypes.Wall.rawValue
        addChild(player)
    }

    func loadLevel() {
        guard let levelPath = NSBundle.mainBundle().pathForResource(
            "level1", ofType: "txt") else { return }
        guard let levelString = try? String(
            contentsOfFile: levelPath, usedEncoding: nil) else { return }
        let lines = levelString.componentsSeparatedByString("\n")

        for (row, line) in lines.reverse().enumerate() {
            for (column, letter) in line.characters.enumerate() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)

                var node: SKSpriteNode
                switch letter {
                    case "x":
                        node = createWall(position)
                    case "v":
                        node = createVortex(position)
                    case "s":
                        node = createStar(position)
                    case "f":
                        node = createFinish(position)
                    default: continue
                }

                addChild(node)
            }
        }
    }

    func createWall(position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
        node.physicsBody!.categoryBitMask = CollisionTypes.Wall.rawValue
        node.physicsBody!.dynamic = false
        return node
    }

    func createVortex(position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.runAction(SKAction.repeatActionForever(
            SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
            ))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody!.dynamic = false
        node.physicsBody!.categoryBitMask = CollisionTypes.Vortex.rawValue
        node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
        return node
    }

    func createStar(position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody!.dynamic = false
        node.physicsBody!.categoryBitMask = CollisionTypes.Star.rawValue
        node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
        node.position = position
        return node
    }

    func createFinish(position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody!.dynamic = false
        node.physicsBody!.categoryBitMask = CollisionTypes.Finish.rawValue
        node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
        node.position = position
        return node
    }

    func loadBackground() {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)
    }

    func createScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first { lastTouchPosition = touch.locationInNode(self) }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first { lastTouchPosition = touch.locationInNode(self) }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastTouchPosition = nil
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        lastTouchPosition = nil
    }

    override func update(currentTime: CFTimeInterval) {
        if gameOver { return }
        #if (arch(i386) || arch(x86_64))
            guard let currentTouch = lastTouchPosition else { return }
            let diff = CGPoint(
                x: currentTouch.x - player.position.x,
                y: currentTouch.y - player.position.y
            )
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        #else
            guard let accelerometerData = motionManager.accelerometerData else { return }
            physicsWorld.gravity = CGVector(
                dx: accelerometerData.acceleration.y * -50,
                dy: accelerometerData.acceleration.x * 50
            )
        #endif
    }
}
