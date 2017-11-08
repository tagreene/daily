//
//  AppDelegateExtension.swift
//  Daily
//
//  Created by Trent Greene on 11/7/17.
//  Copyright © 2017 greene. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    class func isIPhone5 () -> Bool{
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 568.0
    }
    
    class func isIPhonePlus () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 736.0
    }
    
    class func isIPhoneX () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 812.0
    }
}
