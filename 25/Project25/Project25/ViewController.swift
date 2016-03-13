//
//  ViewController.swift
//  Project25
//
//  Created by Mike Stubna on 3/13/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var collectionView: UICollectionView!
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Camera,
            target: self,
            action: "importPicture"
        )
    }

    func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return images.count
    }

    func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            "ImageView",
            forIndexPath: indexPath
        )

        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }

        return cell
    }

    func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]
    ) {
        var newImage: UIImage

        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }

        dismissViewControllerAnimated(true, completion: nil)

        images.insert(newImage, atIndex: 0)
        collectionView.reloadData()
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
