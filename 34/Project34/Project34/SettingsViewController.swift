//
//  SettingsViewController.swift
//  Project34
//
//  Created by Mike Stubna on 4/5/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var playerModeButton: UISwitch!
    @IBOutlet var player1Picker: UIPickerView!
    @IBOutlet var player2Picker: UIPickerView!

    @IBAction func playerModeToggled(sender: UISwitch) {
        sharedUserSettings.twoPlayerMode = sender.on
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        player1Picker.delegate = self
        player1Picker.dataSource = self
        player1Picker.selectRow(
            sharedUserSettings.player1Color ?? 0, inComponent: 0, animated: false
        )

        player2Picker.delegate = self
        player2Picker.dataSource = self
        player2Picker.selectRow(
            sharedUserSettings.player2Color ?? 1, inComponent: 0, animated: false
        )

        playerModeButton.on = sharedUserSettings.twoPlayerMode
    }

    //MARK: Picker Delegates and DataSource

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 && row != sharedUserSettings.player2Color {
            sharedUserSettings.player1Color = row
        } else if pickerView.tag == 2 && row != sharedUserSettings.player1Color {
            sharedUserSettings.player2Color = row
        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Player.names.count
    }

    func pickerView(
        pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return Player.names[row]
    }

}
