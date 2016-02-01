//
//  StatsViewController.swift
//  GasLogger
//
//  Created by Gene Crucean on 1/6/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import UIKit

class StatsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("MPG: \(Stats.getAverageMPG())")
        print("Mileage: \(Stats.getAverageMileage())")
        print("Price: \(Stats.getAveragePrice())")
        print("Gallons: \(Stats.getAverageGallons())")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
