//
//  ViewController.swift
//  Project18
//
//  Created by Mike Stubna on 1/11/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import iAd
import UIKit

class ViewController: UIViewController, ADBannerViewDelegate {

    var bannerView: ADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView = ADBannerView(adType: .Banner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.delegate = self
        bannerView.hidden = true
        view.addSubview(bannerView)

        let viewsDictionary = ["bannerView": bannerView]
        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[bannerView]|",
                options: [],
                metrics: nil,
                views: viewsDictionary
            )
        )
        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[bannerView]|",
                options: [],
                metrics: nil,
                views: viewsDictionary
            )
        )
    }

    func bannerViewDidLoadAd(banner: ADBannerView!) {
        bannerView.hidden = false
    }

    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        bannerView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
