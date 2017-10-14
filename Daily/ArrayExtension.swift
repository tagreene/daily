//
//  ArrayExtension.swift
//  Daily
//
//  Created by Trent Greene on 10/13/17.
//  Copyright © 2017 greene. All rights reserved.
//

import Foundation

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
