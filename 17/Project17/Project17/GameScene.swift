//
//  GameScene.swift
//  Project17
//
//  Created by Mike Stubna on 1/11/16.
//  Copyright (c) 2016 Mike. All rights reserved.
//

import SpriteKit
import AVFoundation

enum SequenceType: Int {
    case OneNoBomb, One, TwoWithOneBomb, Two, Three, Four, Chain, FastChain
}

enum ForceBomb {
    case Never, Always, Default
}

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

    var swooshSoundActive = false

    var activeEnemies = [SKSpriteNode]()

    var bombSoundEffect: AVAudioPlayer!

    var popupTime = 0.9
    var sequence: [SequenceType]!
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequenceQueued = true

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

        sequence = [.OneNoBomb, .OneNoBomb, .TwoWithOneBomb, .TwoWithOneBomb, .Three, .One, .Chain]

        for _ in 0 ... 1000 {
            let nextSequence = SequenceType(rawValue: RandomInt(min: 2, max: 7))!
            sequence.append(nextSequence)
        }

        RunAfterDelay(2) { [unowned self] in
            self.tossEnemies()
        }
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

    func createEnemy(forceBomb forceBomb: ForceBomb = .Default) {
        var enemy = SKSpriteNode()

        var enemyType = RandomInt(min: 0, max: 6)

        if forceBomb == .Never {
            enemyType = 1
        } else if forceBomb == .Always {
            enemyType = 0
        }

        if enemyType == 0 {
            // create a bomb container
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"

            // create bomb image
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)

            // if there is a current bomb sound playing, stop it
            if bombSoundEffect != nil {
                bombSoundEffect.stop()
                bombSoundEffect = nil
            }

            // create a new bomb sound and play it
            let path = NSBundle.mainBundle().pathForResource("sliceBombFuse.caf", ofType:nil)!
            let url = NSURL(fileURLWithPath: path)
            guard let sound = try? AVAudioPlayer(contentsOfURL: url) else { return }
            bombSoundEffect = sound
            sound.play()

            // add fuse image
            let emitter = SKEmitterNode(fileNamed: "sliceFuse.sks")!
            emitter.position = CGPoint(x: 76, y: 64)
            enemy.addChild(emitter)
        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            runAction(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
        }

        // give enemy random position off screen
        let randomPosition = CGPoint(x: RandomInt(min: 64, max: 960), y: -128)

        // give enemy random spin
        let randomAngularVelocity = CGFloat(RandomInt(min: -6, max: 6)) / 2.0

        // create random x velocity based on position
        var randomXVelocity = 0
        if randomPosition.x < 256 {
            randomXVelocity = RandomInt(min: 8, max: 15)
        } else if randomPosition.x < 512 {
            randomXVelocity = RandomInt(min: 3, max: 5)
        } else if randomPosition.x < 768 {
            randomXVelocity = -RandomInt(min: 3, max: 5)
        } else {
            randomXVelocity = -RandomInt(min: 8, max: 15)
        }

        // create random y velocity
        let randomYVelocity = RandomInt(min: 24, max: 32)

        enemy.position = randomPosition
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody!.angularVelocity = randomAngularVelocity
        enemy.physicsBody!.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody!.collisionBitMask = 0 // no collisions

        addChild(enemy)
        activeEnemies.append(enemy)
    }
    func tossEnemies() {
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02

        let sequenceType = sequence[sequencePosition]

        switch sequenceType {
        case .OneNoBomb:
            createEnemy(forceBomb: .Never)

        case .One:
            createEnemy()

        case .TwoWithOneBomb:
            createEnemy(forceBomb: .Never)
            createEnemy(forceBomb: .Always)

        case .Two:
            createEnemy()
            createEnemy()

        case .Three:
            createEnemy()
            createEnemy()
            createEnemy()

        case .Four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()

        case .Chain:
            createEnemy()

            RunAfterDelay(chainDelay / 5.0) { [unowned self] in self.createEnemy() }
            RunAfterDelay(chainDelay / 5.0 * 2) { [unowned self] in self.createEnemy() }
            RunAfterDelay(chainDelay / 5.0 * 3) { [unowned self] in self.createEnemy() }
            RunAfterDelay(chainDelay / 5.0 * 4) { [unowned self] in self.createEnemy() }

        case .FastChain:
            createEnemy()

            RunAfterDelay(chainDelay / 10.0) { [unowned self] in self.createEnemy() }
            RunAfterDelay(chainDelay / 10.0 * 2) { [unowned self] in self.createEnemy() }
            RunAfterDelay(chainDelay / 10.0 * 3) { [unowned self] in self.createEnemy() }
            RunAfterDelay(chainDelay / 10.0 * 4) { [unowned self] in self.createEnemy() }
        }

        sequencePosition += 1
        nextSequenceQueued = false
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

        if !swooshSoundActive {
            playSwooshSound()
        }
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

    func playSwooshSound() {
        swooshSoundActive = true

        let randomNumber = RandomInt(min: 1, max: 3)
        let soundName = "swoosh\(randomNumber).caf"

        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)

        runAction(swooshSound) { [unowned self] in
            self.swooshSoundActive = false
        }
    }

    override func update(currentTime: CFTimeInterval) {
        var bombCount = 0

        for node in activeEnemies {
            if node.name == "bombContainer" {
                ++bombCount
                break
            }
        }

        if bombCount == 0 {
            // no bombs – stop the fuse sound!
            if bombSoundEffect != nil {
                bombSoundEffect.stop()
                bombSoundEffect = nil
            }
        }

        if activeEnemies.count > 0 {
            for node in activeEnemies {
                if node.position.y < -140 {
                    node.removeFromParent()

                    if let index = activeEnemies.indexOf(node) {
                        activeEnemies.removeAtIndex(index)
                    }
                }
            }
        } else {
            if !nextSequenceQueued {
                RunAfterDelay(popupTime) { [unowned self] in
                    self.tossEnemies()
                }

                nextSequenceQueued = true
            }
        }
    }
}
