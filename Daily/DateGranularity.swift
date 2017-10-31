//
//  DateGranularity.swift
//  Daily
//
//  Created by Trent Greene on 10/30/17.
//  Copyright © 2017 greene. All rights reserved.
//

import Foundation

enum DateGranularity {
    case daily
    case weekly
    case monthly
    case yearly
    
    init(_ count: Int){
        switch count {
        case Int.min...21: self = .daily
        case 22...147: self = .weekly
        case 148...730: self = .monthly
        case 731...Int.max: self = .yearly
        default:
            fatalError("Error with Data Granularity")
        }
    }
}
