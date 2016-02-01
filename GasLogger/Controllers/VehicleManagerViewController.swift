//
//  VehicleManagerViewController.swift
//  GasLogger
//
//  Created by Gene Crucean on 1/31/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class VehicleManagerViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

//    var vehicles: [Vehicle]? = nil
    @IBOutlet weak var tableView: UITableView!
    var vehicles: Results<Vehicle>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Nav bar logo.
        let navBarLogo = StyleKit.imageOfNavbar_vehicles
        let navBarLogoView = UIImageView(image: navBarLogo)
        self.navigationItem.titleView = navBarLogoView
        
        // Get rid of cell separators.
        tableView.tableFooterView = UIView()
        
        loadVehicleData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        loadVehicleData()
        
        self.navigationController?.hidesBarsOnTap = false
        
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
    
    
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let vehicles = vehicles
        {
            return vehicles.count
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("vehicleCell", forIndexPath: indexPath)
        
        // Initialize basic cell properties.
        cell.textLabel?.textColor = StyleKit.white
        cell.accessoryView = UIImageView(image: StyleKit.imageOfCheckMark)
        cell.accessoryView?.hidden = true
        
        if let vehicles = vehicles
        {
            print(vehicles[indexPath.row].name)
            cell.textLabel?.text = vehicles[indexPath.row].name
            
            // Add checkmark to selected cell.
            if let currentVehicleName = NSUserDefaults.standardUserDefaults().objectForKey(CONSTANTS.NSUSERDEFAULTS.CURRENTLY_SELECTED_VEHICLE_NAME) as? String
            {
                if cell.textLabel?.text == currentVehicleName
                {
                    cell.accessoryView?.hidden = false
                }
                else
                {
                    cell.accessoryView?.hidden = true
                }
            }
            
            
            return cell
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if let vehicleName = cell?.textLabel?.text
        {
            NSUserDefaults.standardUserDefaults().setObject(vehicleName, forKey: CONSTANTS.NSUSERDEFAULTS.CURRENTLY_SELECTED_VEHICLE_NAME)
            tableView.reloadData()
        }
        
       
    }
    
    // Delete entry from db.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            if let vehicles = vehicles
            {
                // Delete entry from db.
                RealmManager.deleteVehicle(vehicles[indexPath.row])
                
                // Select first vehicle in table. Convenience.
                let rowToSelect = NSIndexPath(forRow: 0, inSection: 0)
                let cell = tableView.cellForRowAtIndexPath(rowToSelect)
                
                if let vehicleName = cell?.textLabel?.text
                {
                    NSUserDefaults.standardUserDefaults().setObject(vehicleName, forKey: CONSTANTS.NSUSERDEFAULTS.CURRENTLY_SELECTED_VEHICLE_NAME)
                }
                
                // Reload data in memory for display.
                loadVehicleData()
            }
        }
    }

    
    // MARK: - METHODS
    
    func loadVehicleData()
    {
        vehicles = RealmManager.getAllVehicles()
        tableView.reloadData()
    }
    
    
    // MARK: - DZNEmptyTableView Delegate & DataSource.
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage!
    {
        return StyleKit.imageOfVehicleIcon3
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Zero, Zip, Zilch, Nada Vehicles"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Please tap the + icon and add a new vehicle."
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.ByWordWrapping
        para.alignment = NSTextAlignment.Center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSParagraphStyleAttributeName: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
}
