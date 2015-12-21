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
    @IBOutlet var intensityView: UIView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var scaleView: UIView!
    @IBOutlet var scale: UISlider!

    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!

    @IBAction func changeFilter(sender: UIButton) {
        let ac = UIAlertController(
            title: "Choose filter",
            message: nil,
            preferredStyle: .ActionSheet
        )
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }

    @IBAction func save(sender: UIButton) {
        guard currentImage != nil else { return }
        UIImageWriteToSavedPhotosAlbum(
            imageView.image!,
            self,
            "image:didFinishSavingWithError:contextInfo:",
            nil
        )
    }

    @IBAction func intensityChanges(sender: UISlider) {
        applyProcessing()
    }

    @IBAction func scaleChanged(sender: UISlider) {
        applyProcessing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
            target: self, action: "importPicture")

        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CISepiaTone")
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

        currentImage = newImage

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        updateControls()
        guard currentImage != nil else { return }

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(scale.value * 200, forKey: kCIInputRadiusKey)
        }

        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(
                CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2),
                forKey: kCIInputCenterKey
            )
        }

        let cgimg = context.createCGImage(
            currentFilter.outputImage!,
            fromRect: currentFilter.outputImage!.extent
        )
        self.imageView.image = UIImage(CGImage: cgimg)
    }

    func setFilter(action: UIAlertAction!) {
        currentFilter = CIFilter(name: action.title!)

        guard currentImage != nil else { return }
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }

    func updateControls() {
        let inputKeys = currentFilter.inputKeys

        intensityView.hidden = !inputKeys.contains(kCIInputIntensityKey)

        scaleView.hidden = !(inputKeys.contains(kCIInputScaleKey) ||
            inputKeys.contains(kCIInputRadiusKey))
    }

    func image(
        image: UIImage,
        didFinishSavingWithError error: NSError?,
        contextInfo:UnsafePointer<Void>
    ) {
        if error == nil {
            let ac = UIAlertController(
                title: "Saved!",
                message: "Your altered image has been saved to your photos.",
                preferredStyle: .Alert
            )
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(
                title: "Save error", message: error?.localizedDescription,
                preferredStyle: .Alert
            )
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
