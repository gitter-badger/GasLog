//
//  RealmManager.swift
//  GasLogger
//
//  Created by Gene Crucean on 1/3/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {

    // MARK: - Entry
    class func addEntryToVehicle(vehicle: Vehicle, date: NSDate, mileage: Int, gallons: Double, price: Double, lat: Double = 0.0, lon: Double = 0.0)
    {
        // Get last mileage and calculate mpg.
        var mpg = 0
        if let lastEntry = vehicle.entries.sorted("date", ascending: true).last
        {
            let milesDriven = mileage - lastEntry.mileage
            mpg = milesDriven / Int(gallons)
        }
        
        // Build Entry.
        let entry = Entry()
        entry.uuid = NSUUID().UUIDString
        entry.mileage = mileage
        entry.gallons = gallons
        entry.price = price
        entry.date = date
        entry.mpg = mpg
        entry.lat = lat
        entry.lon = lon
        
        print(entry)
        
        try! Realm().write {
            vehicle.entries.append(entry)
            NSNotificationCenter.defaultCenter().postNotificationName(CONSTANTS.NOTI.ENTRY_ADDED, object: nil)
        }
    }
    
    class func deleteEntry(entry: Entry)
    {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(entry)
        }
    }
    
    // MARK: - Vehicle
    class func addVehicleToDB(vehicle: Vehicle)
    {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(vehicle)
        }
    }
    
    class func getAllVehicles() -> Results<Vehicle>?
    {
        if let vehicles = try? Realm().objects(Vehicle)
        {
            return vehicles
        }
        else
        {
            return nil
        }
    }
    
    class func deleteVehicle(vehicle: Vehicle)
    {
        let realm = try! Realm()
        
        // Delete all entries for vehicle.
        for entry in vehicle.entries
        {
            try! realm.write {
                realm.delete(entry)
            }
        }

        // Delete vehicle.
        try! realm.write {
            realm.delete(vehicle)
        }
        
        
    }
}
