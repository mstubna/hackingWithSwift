//
//  GameScene.swift
//  Project20
//
//  Created by Mike Stubna on 1/18/16.
//  Copyright (c) 2016 Mike. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {

    var gameTimer: NSTimer!
    var fireworks = [SKNode]()

    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22

    var score: Int = 0 {
        didSet {
            // your code here
        }
    }

    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)

        gameTimer = NSTimer.scheduledTimerWithTimeInterval(
            6,
            target: self,
            selector: "launchFireworks",
            userInfo: nil,
            repeats: true
        )
    }

    func createFirework(xMovement xMovement: CGFloat, xPosition: Int, yPosition: Int) {
        // 1
        let node = SKNode()
        node.position = CGPoint(x: xPosition, y: yPosition)

        // 2
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.name = "firework"
        node.addChild(firework)

        // 3
        switch GKRandomSource.sharedRandom().nextIntWithUpperBound(3) {
        case 0:
            firework.color = UIColor.cyanColor()
            firework.colorBlendFactor = 1

        case 1:
            firework.color = UIColor.greenColor()
            firework.colorBlendFactor = 1

        case 2:
            firework.color = UIColor.redColor()
            firework.colorBlendFactor = 1

        default:
            break
        }

        // 4
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: xMovement, y: 1000))

        // 5
        let move = SKAction.followPath(path.CGPath, asOffset: true, orientToPath: true, speed: 200)
        node.runAction(move)

        // 6
        let emitter = SKEmitterNode(fileNamed: "fuse.sks")!
        emitter.position = CGPoint(x: 0, y: -22)
        node.addChild(emitter)

        // 7
        fireworks.append(node)
        addChild(node)
    }

    func launchFireworks() {
        let movementAmount: CGFloat = 1800
   
        switch GKRandomSource.sharedRandom().nextIntWithUpperBound(4) {
        case 0:
            // fire five, straight up
            createFirework(xMovement: 0, xPosition: 512, yPosition: bottomEdge)
            createFirework(xMovement: 0, xPosition: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, xPosition: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, xPosition: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, xPosition: 512 + 200, y: bottomEdge)
   
        case 1:
            // fire five, in a fan
            createFirework(xMovement: 0, xPosition: 512, y: bottomEdge)
            createFirework(xMovement: -200, xPosition: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
   
        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
   
        case 3:
            // fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
   
        default:
            break
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }

    override func update(currentTime: CFTimeInterval) {
    }
}
