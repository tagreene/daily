//
//  OurTabBarController.swift
//  Daily
//
//  Created by Trent Greene on 9/26/17.
//  Copyright © 2017 greene. All rights reserved.
//

import UIKit

class OurTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let newEntryViewController = NewEntryViewController()
        newEntryViewController.title = "Write  " // Add two spaces to end of string for spacing (Free Logos Suck - Change the Logo)
        newEntryViewController.tabBarItem.image = UIImage(named: "WriteIcon")
        
        let analyticsViewController = AnalyticsViewController()
        analyticsViewController.title = "Analytics "
        analyticsViewController.tabBarItem.image = UIImage(named: "AnalyticsIcon")
        
        let readerViewController = ReaderViewController()
        readerViewController.title = "Read"
        readerViewController.tabBarItem.image = UIImage(named: "ReadIcon")
        
        // Randomize whether the readerViewController appears
        if arc4random_uniform(1) == 0 {
            viewControllers = [newEntryViewController, analyticsViewController, readerViewController]
        } else {
            viewControllers = [newEntryViewController, analyticsViewController]
        }
    }
    
}
