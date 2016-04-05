//
//  SettingsViewController.swift
//  Project34
//
//  Created by Mike Stubna on 4/5/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var playerModeButton: UISwitch!

    @IBAction func playerModeToggled(sender: UISwitch) {
        sharedUserSettings.twoPlayerMode = sender.on
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        playerModeButton.on = sharedUserSettings.twoPlayerMode
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
