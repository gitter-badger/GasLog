//
//  SettingsViewController.swift
//  GasLogger
//
//  Created by Gene Crucean on 1/8/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import UIKit

class SettingsNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarItem.image = StyleKit.imageOfSettings_normal
        tabBarItem.selectedImage = StyleKit.imageOfSettings_selected
        tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
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
