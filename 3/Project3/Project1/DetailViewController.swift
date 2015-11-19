//
//  DetailViewController.swift
//  Project1
//
//  Created by Mike Stubna on 11/17/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailNavigationView: UINavigationItem!

    var detailItem: String? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let imageView = self.detailImageView {
                imageView.image = UIImage(named: detail)
            }
            if let navigationView = self.detailNavigationView {
                navigationView.title = detail
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareTapped")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    func shareTapped() {
        let vc = UIActivityViewController(activityItems: [detailImageView.image!], applicationActivities: [])
        presentViewController(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

