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
    @IBOutlet var radiusView: UIView!
    @IBOutlet var radius: UISlider!
    @IBOutlet var changeFilterButton: UIButton!

    var currentImage: UIImage!
    var context: CIContext!

    let filters = [
        "CIBumpDistortion": "Bump",
        "CIGaussianBlur": "Blur",
        "CIPixellate": "Pixellate",
        "CISepiaTone": "Sepia",
        "CITwirlDistortion": "Swirl",
        "CIUnsharpMask": "Unsharp",
        "CIVignette": "Vignette"
    ]

    var currentFilter: CIFilter! {
        didSet {
            changeFilterButton.setTitle(
                filters[currentFilter.name],
                for: UIControlState()
            )
        }
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(
            title: "Choose filter",
            message: nil,
            preferredStyle: .actionSheet
        )
        for (name, title) in filters {
            ac.addAction(UIAlertAction(
                title: title,
                style: .default,
                handler: { [unowned self] (action: UIAlertAction) in
                    self.setFilter(name)
            }))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIButton) {
        guard currentImage != nil else { return }
        UIImageWriteToSavedPhotosAlbum(
            imageView.image!,
            self,
            #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }

    @IBAction func intensityChanges(_ sender: UISlider) {
        applyProcessing()
    }

    @IBAction func scaleChanged(_ sender: UISlider) {
        applyProcessing()
    }

    @IBAction func radius(_ sender: UISlider) {
        applyProcessing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "FilterApp"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
            target: self, action: #selector(ViewController.importPicture))

        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CISepiaTone")
        updateControls()
    }

    func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
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

        dismiss(animated: true, completion: nil)

        currentImage = newImage

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func applyProcessing() {
        updateControls()

        guard currentImage != nil else { return }

        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
        }

        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(
                CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2),
                forKey: kCIInputCenterKey
            )
        }

        let cgimg = context.createCGImage(
            currentFilter.outputImage!,
            from: currentFilter.outputImage!.extent
        )
        self.imageView.image = UIImage(cgImage: cgimg!)
    }

    func setFilter(_ name: String) {
        currentFilter = CIFilter(name: name)

        if currentImage != nil {
            let beginImage = CIImage(image: currentImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        }

        applyProcessing()
    }

    func updateControls() {
        let inputKeys = currentFilter.inputKeys

        intensityView.isHidden = !inputKeys.contains(kCIInputIntensityKey)
        scaleView.isHidden = !inputKeys.contains(kCIInputScaleKey)
        radiusView.isHidden = !inputKeys.contains(kCIInputRadiusKey)
    }

    func image(
        _ image: UIImage,
        didFinishSavingWithError error: NSError?,
        contextInfo: UnsafePointer<Void>
    ) {
        if error == nil {
            let ac = UIAlertController(
                title: "Saved!",
                message: "Your altered image has been saved to your photos.",
                preferredStyle: .alert
            )
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(
                title: "Save error", message: error?.localizedDescription,
                preferredStyle: .alert
            )
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
