//
//  UIViewExtension.swift
//  Daily
//
//  Created by Trent Greene on 9/29/17.
//  Copyright © 2017 greene. All rights reserved.
//

// Extend UIView to allow general vertical and horizontal animations

import UIKit

// Add horizontal shake
extension UIView {
    func shakeHorizontally(_ completionBlock: @escaping () -> Void){
        CATransaction.begin()
        CATransaction.setCompletionBlock(completionBlock)
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))
        self.layer.add(animation, forKey: "position")
        CATransaction.commit()
    }
}

extension UIView {
    func shakeVertically(_ completionBlock: @escaping () -> Void){
        CATransaction.begin()
        CATransaction.setCompletionBlock(completionBlock)
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y + 5))
        self.layer.add(animation, forKey: "position")
        CATransaction.commit()
    }
}

