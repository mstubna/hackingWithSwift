//
//  ViewController.swift
//  Project13
//
//  Created by Mike Stubna on 12/21/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!

    @IBOutlet var intensity: UISlider!

    var currentImage: UIImage!

    @IBAction func changeFilter(sender: UIButton) {

    }

    @IBAction func save(sender: UIButton) {

    }

    @IBAction func intensityChanged(sender: UISlider) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
            target: self, action: "importPicture")
    }

    func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage

        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }

        dismissViewControllerAnimated(true, completion: nil)

        currentImage = newImage
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
