//
//  ViewController.swift
//  Project27
//
//  Created by Mike Stubna on 3/14/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentDrawType = 0

    @IBOutlet var imageView: UIImageView!

    @IBAction func redrawTapped(sender: AnyObject) {
        currentDrawType += 1

        if currentDrawType > 5 {
            currentDrawType = 0
        }

        switch currentDrawType {
        case 0:
            drawRectangle()
        default:
            break
        }
    }

    func drawRectangle() {
        print("hell0")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        drawRectangle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
