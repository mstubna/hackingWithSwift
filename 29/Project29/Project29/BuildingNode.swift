//
//  BuildingNode.swift
//  Project29
//
//  Created by Mike Stubna on 3/15/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class BuildingNode: SKSpriteNode {

    var currentImage: UIImage!

    func setup() {
        name = "building"

        currentImage = drawBuilding(size)
        texture = SKTexture(image: currentImage)

        configurePhysics()
    }

    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody!.dynamic = false
        physicsBody!.categoryBitMask = CollisionTypes.Building.rawValue
        physicsBody!.contactTestBitMask = CollisionTypes.Banana.rawValue
    }

    func drawBuilding(size: CGSize) -> UIImage {
        // Create the context
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()

        // Draw the building
        let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var color: UIColor

        switch GKRandomSource.sharedRandom().nextIntWithUpperBound(3) {
        case 0:
            color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
        case 1:
            color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
        default:
            color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
        }

        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextAddRect(context, rectangle)
        CGContextDrawPath(context, .Fill)

        // Draw the windows
        let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
        let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)

        var row: CGFloat = 10
        while row < size.height - 10 {
            var col: CGFloat = 10
            while col < size.width - 10 {
                if RandomInt(min: 0, max: 1) == 0 {
                    CGContextSetFillColorWithColor(context, lightOnColor.CGColor)
                } else {
                    CGContextSetFillColorWithColor(context, lightOffColor.CGColor)
                }
                CGContextFillRect(context, CGRect(x: col, y: row, width: 15, height: 20))
                col += 40
            }
            row += 40
        }

        // Generate an image from the context
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img
    }

    func hitAtPoint(point: CGPoint) {
        let convertedPoint = CGPoint(
            x: point.x + size.width / 2.0,
            y: abs(point.y - (size.height / 2.0))
        )

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()

        currentImage.drawAtPoint(CGPoint(x: 0, y: 0))

        CGContextAddEllipseInRect(
            context,
            CGRect(x: convertedPoint.x - 32, y: convertedPoint.y - 32, width: 64, height: 64)
        )
        CGContextSetBlendMode(context, .Clear)
        CGContextDrawPath(context, .Fill)

        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        texture = SKTexture(image: img)
        currentImage = img

        configurePhysics()
    }
}
