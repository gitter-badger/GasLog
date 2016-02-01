//
//  Entry.swift
//  GasLogger
//
//  Created by Gene Crucean on 1/3/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import Foundation
import RealmSwift

class Entry: Object {
    
    //////////////////////////////////////////////////
    // Schema v0
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    dynamic var uuid: String = ""
    dynamic var mileage: Int = 0
    dynamic var gallons: Double = 0.0
    dynamic var price: Double = 0.0
    dynamic var date: NSDate = NSDate()
    dynamic var mpg: Int = 0
    dynamic var lat: Double = 0.0
    dynamic var lon: Double = 0.0
    
    
    //////////////////////////////////////////////////
    // Schema v1
}
