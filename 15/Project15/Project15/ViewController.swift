//
//  ViewController.swift
//  Project15
//
//  Created by Mike Stubna on 12/29/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageView: UIImageView!

    var currentAnimation = 0

    @IBOutlet var tap: UIButton!

    @IBAction func tapped(sender: UIButton) {
        tap.hidden = true

        UIView.animateWithDuration(
            1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 5,
            options: [],
            animations: { [unowned self] in
                self.animation()
            }
        ) { [unowned self] (finished: Bool) in
            self.tap.hidden = false
        }

        currentAnimation = (currentAnimation + 1) % 8
    }

    func animation() {
        switch currentAnimation {
        case 0:
            imageView.transform = CGAffineTransformMakeScale(2, 2)

        case 1:
            imageView.transform = CGAffineTransformIdentity

        case 2:
            imageView.transform = CGAffineTransformMakeTranslation(-256, -256)

        case 3:
            imageView.transform = CGAffineTransformIdentity

        case 4:
            imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))

        case 5:
            imageView.transform = CGAffineTransformIdentity

        case 6:
            imageView.alpha = 0.1
            imageView.backgroundColor = UIColor.greenColor()

        case 7:
            imageView.alpha = 1
            imageView.backgroundColor = UIColor.clearColor()

        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
