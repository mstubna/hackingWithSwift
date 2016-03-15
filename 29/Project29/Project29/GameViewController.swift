//
//  GameViewController.swift
//  Project29
//
//  Created by Mike Stubna on 3/15/16.
//  Copyright (c) 2016 Mike. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var currentGame: GameScene!
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!

    @IBAction func angleChanged(sender: UISlider) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }

    @IBAction func velocityChanged(sender: UISlider) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }

    @IBAction func launch(sender: UIButton) {
        angleSlider.hidden = true
        angleLabel.hidden = true
        velocitySlider.hidden = true
        velocityLabel.hidden = true
        launchButton.hidden = true

        currentGame.launch(
            angle: Int(angleSlider.value),
            velocity: Int(velocitySlider.value)
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        angleChanged(angleSlider)
        velocityChanged(velocitySlider)
        activatePlayerNumber(1)

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            guard let skView = self.view as? SKView else { return }
            skView.showsFPS = true
            skView.showsNodeCount = true

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true

            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill

            skView.presentScene(scene)

            // add references between controller and game scene
            currentGame = scene
            scene.viewController = self
        }
    }

    func activatePlayerNumber(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        angleSlider.hidden = false
        angleLabel.hidden = false
        velocitySlider.hidden = false
        velocityLabel.hidden = false
        launchButton.hidden = false
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
