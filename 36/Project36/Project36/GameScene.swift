//
//  GameScene.swift
//  Project36
//
//  Created by Mike Stubna on 4/5/16.
//  Copyright (c) 2016 Mike. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var player: SKSpriteNode!

    override func didMoveToView(view: SKView) {
        createPlayer()
        createSky()
        createBackground()
        createGround()
    }

    func createPlayer() {
        let playerTexture = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)

        addChild(player)

        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        let animation = SKAction.animateWithTextures(
            [playerTexture, frame2, frame3, frame2], timePerFrame: 0.01
        )
        let runForever = SKAction.repeatActionForever(animation)

        player.runAction(runForever)
    }

    func createSky() {
        let topSky = SKSpriteNode(
            color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1),
            size: CGSize(width: frame.width, height: frame.height * 0.67)
        )
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)

        let bottomSky = SKSpriteNode(
            color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1),
            size: CGSize(width: frame.width, height: frame.height * 0.33)
        )

        topSky.position = CGPoint(x: CGRectGetMidX(frame), y: frame.size.height)
        bottomSky.position = CGPoint(x: CGRectGetMidX(frame), y: bottomSky.frame.height / 2)

        addChild(topSky)
        addChild(bottomSky)

        bottomSky.zPosition = -40
        topSky.zPosition = -40
    }

    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background")

        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.position = CGPoint(
                x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i),
                y: 100
            )
            addChild(background)

            let moveLeft = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatActionForever(moveLoop)

            background.runAction(moveForever)
        }
    }

    func createGround() {
        let groundTexture = SKTexture(imageNamed: "ground")

        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(
                x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))),
                y: groundTexture.size().height / 2
            )

            addChild(ground)

            let moveLeft = SKAction.moveByX(-groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveByX(groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatActionForever(moveLoop)

            ground.runAction(moveForever)
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }

    override func update(currentTime: CFTimeInterval) {
    }
}
