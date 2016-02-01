//
//  Vehicle.swift
//  GasLogger
//
//  Created by Gene Crucean on 1/3/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import Foundation
import RealmSwift

class Vehicle: Object {
    
    //////////////////////////////////////////////////
    // Schema v0
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    dynamic var uuid: String = ""
    dynamic var name: String = ""
    var entries = List<Entry>()
    
    //////////////////////////////////////////////////
    // Schema v1
}
