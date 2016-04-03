//
//  ViewController.swift
//  Project33
//
//  Created by Mike Stubna on 3/25/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static var dirty = true

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "What's that Whistle?"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: #selector(ViewController.addWhistle)
        )
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Home",
            style: .Plain,
            target: nil,
            action: nil
        )
    }

    func addWhistle() {
        let vc = RecordWhistleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
