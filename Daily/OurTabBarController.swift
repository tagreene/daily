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
        analyticsViewController.title = "Analytics"
        analyticsViewController.tabBarItem.image = UIImage(named: "AnalyticsIcon")
        
        let diaryViewController = DiaryViewController()
        diaryViewController.title = "Read"
        diaryViewController.tabBarItem.image = UIImage(named: "ReadIcon")
        
        if arc4random_uniform(7) == 0 {
            viewControllers = [newEntryViewController, analyticsViewController, diaryViewController]
        } else {
            viewControllers = [newEntryViewController, analyticsViewController]
        }
    }
    
}
