//
//  GameScene.swift
//  Project17
//
//  Created by Mike Stubna on 1/11/16.
//  Copyright (c) 2016 Mike. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var gameScore: SKLabelNode!
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }

    var livesImages = [SKSpriteNode]()
    var lives = 3

    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var activeSlicePoints = [CGPoint]()

    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)

        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85

        createScore()
        createLives()
        createSlices()
    }

    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.horizontalAlignmentMode = .Left
        gameScore.fontSize = 48
        gameScore.position = CGPoint(x: 8, y: 8)

        addChild(gameScore)
    }

    func createLives() {
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)

            livesImages.append(spriteNode)
            addChild(spriteNode)
        }
    }

    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2

        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 2

        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9

        activeSliceFG.strokeColor = UIColor.whiteColor()
        activeSliceFG.lineWidth = 5

        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)

        activeSlicePoints.removeAll(keepCapacity: true)

        guard let touch = touches.first else { return }
        let location = touch.locationInNode(self)
        activeSlicePoints.append(location)

        redrawActiveSlice()

        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()

        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.locationInNode(self)

        activeSlicePoints.append(location)
        redrawActiveSlice()
    }

    override func touchesEnded(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        activeSliceBG.runAction(SKAction.fadeOutWithDuration(0.25))
        activeSliceFG.runAction(SKAction.fadeOutWithDuration(0.25))
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touches = touches {
            touchesEnded(touches, withEvent: event)
        }
    }

    func redrawActiveSlice() {
        // don't draw a path if there are less than 2 points
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }

        // only keep the last 12 points
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }

        // create a Bezier path object
        let path = UIBezierPath()
        path.moveToPoint(activeSlicePoints[0])
        for point in activeSlicePoints {
            path.addLineToPoint(point)
        }

        activeSliceBG.path = path.CGPath
        activeSliceFG.path = path.CGPath
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
