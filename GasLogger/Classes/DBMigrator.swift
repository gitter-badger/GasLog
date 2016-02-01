//
//  DBMigrator.swift
//  GasLogger
//
//  Created by Gene Crucean on 1/3/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import UIKit

class DBMigrator: NSObject {

    // Thic function migrates the legacy sqlite database into realm.
    class func migrateSqliteToRealm(sqliteDBPath: String)
    {
        let database = FMDatabase(path: sqliteDBPath)
        
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        let vehicle = Vehicle()
        vehicle.uuid = NSUUID().UUIDString
        vehicle.name = "Migrated"
        NSUserDefaults.standardUserDefaults().setObject(vehicle.name, forKey: CONSTANTS.NSUSERDEFAULTS.CURRENTLY_SELECTED_VEHICLE_NAME)
        
        let resultSet = database.executeQuery("SELECT * FROM gas ORDER BY id ASC", withArgumentsInArray: nil)
        while resultSet.next()
        {
            let entry = Entry()
            entry.uuid = NSUUID().UUIDString
            entry.mileage = Int(resultSet.intForColumn("mileage"))
            entry.gallons = resultSet.doubleForColumn("gallons")
            entry.price = resultSet.doubleForColumn("price")
            
            if let date = Double(resultSet.stringForColumn("date"))
            {
                entry.date = NSDate(timeIntervalSince1970: date)
            }
            
            entry.mpg = Int(resultSet.intForColumn("mpg"))
            
            vehicle.entries.append(entry)
        }
        
        RealmManager.addVehicleToDB(vehicle)
        
        database.close()
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "LegacyMigrationComplete")
        
        print("Database has been migrated from sqlite to realm")
    }
}
