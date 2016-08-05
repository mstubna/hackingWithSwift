//
//  RoundRectButton.swift
//  Project13
//
//  Created by Mike Stubna on 12/22/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import Foundation
import UIKit

class RoundRectButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = UIColor.clear()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = self.tintColor.cgColor
        self.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    }
}
