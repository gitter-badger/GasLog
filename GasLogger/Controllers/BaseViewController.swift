//
//  BaseViewController.swift
//  GasLogger
//
//  Created by Gene Crucean on 1/6/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tab bar appearance.
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        tabBarController?.tabBar.translucent = false
        
        // Nav bar logo.
        let navBarLogo = StyleKit.imageOfNavbar_logo_small
        let navBarLogoView = UIImageView(image: navBarLogo)
        
        self.navigationItem.titleView = navBarLogoView
        
        navigationController?.navigationBar.barTintColor = StyleKit.blue
        navigationController?.navigationBar.translucent = false
        
        UIApplication.sharedApplication().statusBarHidden = false
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.view.backgroundColor = StyleKit.blue
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
