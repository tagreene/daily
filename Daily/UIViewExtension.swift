//
//  UIViewExtension.swift
//  Daily
//
//  Created by Trent Greene on 9/29/17.
//  Copyright © 2017 greene. All rights reserved.
//

// Extend UIView to allow general vertical and horizontal animations

import UIKit

extension UIView {
    
    // Add Horizontal and Vertical Animation
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
    
    // Add Constraint Method for ReaderCells
    func addConstraints(withVisualFormat format: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

