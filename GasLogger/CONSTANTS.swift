//
//  CONSTANTS.swift
//  GasLogger
//
//  Created by Gene Crucean on 7/13/15.
//  Copyright (c) 2015 Dagger Dev. All rights reserved.
//

struct CONSTANTS {
    
    // If it doesn't fall into another category, either create one if there are going to be at least a few entries. Otherwise, put it in general if that makes more sense.
    struct GENERAL {
        
    }
    
    struct NOTI {
        static let ENTRY_ADDED = "entryAddedToDB"
    }
    
    struct NSUSERDEFAULTS {
        static let CURRENTLY_SELECTED_VEHICLE_NAME = "currentlySelectedVehicleName"
    }
    
    struct PATH {
        
    }
    
    
    struct DEVICE {
        static let IS_IPHONE6p = Double(fabs(UIScreen.mainScreen().bounds.size.height - 736)) < DBL_EPSILON
        static let IS_IPHONE6 = Double(fabs(UIScreen.mainScreen().bounds.size.height - 667)) < DBL_EPSILON
        static let IS_IPHONE5 = Double(fabs(UIScreen.mainScreen().bounds.size.height - 568)) < DBL_EPSILON
        static let IS_IPHONE = UIDevice.currentDevice().model == "iPhone"
        static let IS_IPOD = UIDevice.currentDevice().model == "iPod touch"
        static let IS_IPAD = UIDevice.currentDevice().model == "iPad"
        static let IS_SIMULATOR = UIDevice.currentDevice().model == "iPhone Simulator"
    }
}
