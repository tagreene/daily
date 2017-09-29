//
//  Entry.swift
//  Daily
//
//  Created by Trent Greene on 9/6/17.
//  Copyright © 2017 greene. All rights reserved.
//

import Foundation

class Entry {
    var entryText: String
    var entryDate: Date
    
    init(entryText: String) {
        self.entryText = entryText
        self.entryDate = Date()
    }
}
