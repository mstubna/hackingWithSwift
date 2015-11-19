//
//  ViewController.swift
//  Project2
//
//  Created by Mike Stubna on 11/19/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        styleButton(button1)
        styleButton(button2)
        styleButton(button3)
        
        askQuestion()
    }
    
    func styleButton(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGrayColor().CGColor
    }

    func askQuestion() {
        button1.setImage(UIImage(named: countries[0]), forState: .Normal)
        button2.setImage(UIImage(named: countries[1]), forState: .Normal)
        button3.setImage(UIImage(named: countries[2]), forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

