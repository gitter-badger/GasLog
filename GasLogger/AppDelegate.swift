//
//  AppDelegate.swift
//  GasLogger
//
//  Created by Gene Crucean on 9/29/15.
//  Copyright © 2015 Dagger Dev. All rights reserved.
//

import UIKit
import Realm
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        ///////////////////////////////////////////
        // TMP for migration to Realm. This is just to dump the old sqlite file into the documents dir... to mimic the existing app.
        let fileManager = NSFileManager.defaultManager()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let dbPath = documentsPath.stringByAppendingString("/gaslogger.sqlite")

        // This is purely to test with a sample db. gaslogger.sqlite included in the bundle. Turn on it's target membership to test sqlite to realm migration code.
        if !fileManager.fileExistsAtPath(dbPath)
        {
            if let oldDB = NSBundle.mainBundle().pathForResource("gaslogger", ofType: ".sqlite")
            {
                let _ = try! fileManager.copyItemAtPath(oldDB, toPath: dbPath)
                
                migrateDB(dbPath)
            }
            else
            {
                // Setup db one time.
                print("Setup reqired.")
            }
        }
        else
        {
            migrateDB(dbPath)
        }

        ///////////////////////////////////////////
        
        /////////////////////////////////////////
        // Realm.
        print("Realm path: " + RLMRealm.defaultRealm().path)
        
        // Tab bar appearance.
        UITabBar.appearance().barTintColor = StyleKit.blue
        UITabBar.appearance().tintColor = StyleKit.red
        
        return true
    }
    
    func migrateDB(dbPath: String)
    {
        // Migrate any legacy sqlite db's to Realm.
        if (!NSUserDefaults.standardUserDefaults().boolForKey("LegacyMigrationComplete"))
        {
            DBMigrator.migrateSqliteToRealm(dbPath)
        }
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

