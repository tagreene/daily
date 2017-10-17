//
//  ReaderViewController.swift
//  Daily
//
//  Created by Trent Greene on 9/26/17.
//  Copyright © 2017 greene. All rights reserved.
//

import UIKit

class ReaderViewController: UIViewController {
    var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradient()
        setUpContainerView()
    }
    
    func setUpContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 0.1)
        containerView.layer.cornerRadius = 5
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        let margins = view.layoutMarginsGuide
        containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        if #available(iOS 11, *) {
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        } else {
            containerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8).isActive = true
            containerView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8).isActive = true
        }
    }
    
    func addGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.view.frame.size
        gradient.colors = [UIColor.init(red: 255.0/255.0, green: 250.0/255.0, blue: 215.0/255.0, alpha: 1.0).cgColor, UIColor.init(red: 255.0/255.0, green: 250.0/255.0, blue: 215.0/255.0, alpha: 0.5).cgColor]
        gradient.endPoint = CGPoint.init(x: 1.0, y: 0.25)
        gradient.startPoint = CGPoint.init(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
}
