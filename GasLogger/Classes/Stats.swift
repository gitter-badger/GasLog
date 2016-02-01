//
//  Stats.swift
//  GasLogger
//
//  Created by Gene Crucean on 1/10/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import UIKit
import RealmSwift

class Stats: NSObject {

    // Calculate average mpg.
    class func getAverageMPG() -> Int
    {
        // Get current vehicle.
        if let vehicle = try! Realm().objects(Vehicle).first
        {
            // Get all entries for vehicle.
            let entries = vehicle.entries.sorted("date", ascending: true)
            
            // Loop through all entries and get average mpg.
            var mpg = 0
            for entry in entries
            {
                mpg += entry.mpg
            }
            
            return mpg / entries.count
        }
        
        return 0
    }
    
    // Calculate average mileage.
    class func getAverageMileage() -> Int
    {
        // Get current vehicle.
        if let vehicle = try! Realm().objects(Vehicle).first
        {
            // Get all entries for vehicle.
            let entries = vehicle.entries.sorted("date", ascending: true)
            
            // Loop through all entries and get average mpg.
            var mileage = 0
            for entry in entries
            {
                mileage += entry.mileage
            }
            
            return mileage / entries.count
        }
        
        return 0
    }
    
    // Calculate average price.
    class func getAveragePrice() -> Double
    {
        // Get current vehicle.
        if let vehicle = try! Realm().objects(Vehicle).first
        {
            // Get all entries for vehicle.
            let entries = vehicle.entries.sorted("date", ascending: true)
            
            // Loop through all entries and get average mpg.
            var price = 0.0
            for entry in entries
            {
                price += entry.price
            }
            
            return price / Double(entries.count)
        }
        
        return 0
    }
    
    // Calculate average gallons.
    class func getAverageGallons() -> Double
    {
        // Get current vehicle.
        if let vehicle = try! Realm().objects(Vehicle).first
        {
            // Get all entries for vehicle.
            let entries = vehicle.entries.sorted("date", ascending: true)
            
            // Loop through all entries and get average mpg.
            var gallons = 0.0
            for entry in entries
            {
                gallons += entry.gallons
            }
            
            return gallons / Double(entries.count)
        }
        
        return 0
    }

}
