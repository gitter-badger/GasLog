//
//  EntriesViewController.swift
//  GasLogger
//
//  Created by Gene Crucean on 1/3/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation
import Material
import DZNEmptyDataSet

class EntriesViewController: BaseViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TextFieldDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateTextField: TextField!
    @IBOutlet weak var odometerTextField: TextField!
    @IBOutlet weak var gallonsTextField: TextField!
    @IBOutlet weak var priceTextField: TextField!
    
    @IBOutlet weak var currentVehicleLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var date = NSDate()
    var lat = 0.0
    var lon = 0.0
    var gpsQueryLimit = 0
    
    var entries = [Entry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadVehicleData", name: CONSTANTS.NOTI.ENTRY_ADDED, object: nil)
        
        tableView.estimatedRowHeight = 23.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Set current date into UI. This is just a starting point... which is... now.
        dateTextField.text = updateDateInUI(NSDate())
        
        // Get rid of cell separators.
        tableView.tableFooterView = UIView()
        
        // Basic ui settings.
        setupTextFields()
        
        // Test if any vehicles exist in DB. If not, prompt user to enter one.
//        if !vehiclesExist()
//        {
//            let noti = UIAlertController(title: nil, message: "You haven't added any vehicles yet. Please tap the menu button in the top left to add your whip.", preferredStyle: .Alert)
//            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
//                
//            })
//            
//            noti.addAction(okAction)
//            
//            self.presentViewController(noti, animated: true, completion: nil)
//        }
        
        if CLLocationManager.locationServicesEnabled()
        {
            // Ask for GPS Auth.
            locationManager.requestAlwaysAuthorization()
            
            // For use in foreground.
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.hidesBarsOnTap = false
        
        loadVehicleData()
        reloadTable()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        if let vehicleName = NSUserDefaults.standardUserDefaults().objectForKey(CONSTANTS.NSUSERDEFAULTS.CURRENTLY_SELECTED_VEHICLE_NAME) as? String
        {
            currentVehicleLabel.text = vehicleName
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Methods
    @IBAction func addNewEntryButton(sender: AnyObject) {
        addNewEntry()
    }
    
    func addNewEntry()
    {
        if let currentVehicleName = NSUserDefaults.standardUserDefaults().objectForKey(CONSTANTS.NSUSERDEFAULTS.CURRENTLY_SELECTED_VEHICLE_NAME) as? String
        {
            if let vehicle = try! Realm().objects(Vehicle).filter("name == '\(currentVehicleName)'").first
            {
                if let mileage = odometerTextField.text, gallons = gallonsTextField.text, price = priceTextField.text
                {
                    if mileage != "" && gallons != "" && price != ""
                    {
                        RealmManager.addEntryToVehicle(vehicle, date: date, mileage: Int(mileage)!, gallons: Double(gallons)!, price: Double(price)!, lat: lat, lon: lon)
                        
                        dateTextField.text = updateDateInUI(NSDate())
                        odometerTextField.text = ""
                        gallonsTextField.text = ""
                        priceTextField.text = ""
                    }
                }
                else
                {
                    warnUserNoti()
                }
            }
            else // Initial setup of vehicle.
            {
                if let mileage = odometerTextField.text, gallons = gallonsTextField.text, price = priceTextField.text
                {
                    if mileage != "" && gallons != "" && price != ""
                    {
                        // Create vehicle first.
                        let vehicle = Vehicle()
                        vehicle.uuid = NSUUID().UUIDString
                        vehicle.name = "Placeholder"
                        RealmManager.addVehicleToDB(vehicle)
                        
                        RealmManager.addEntryToVehicle(vehicle, date: date, mileage: Int(mileage)!, gallons: Double(gallons)!, price: Double(price)!, lat: lat, lon: lon)
                        
                        dateTextField.text = updateDateInUI(NSDate())
                        odometerTextField.text = ""
                        gallonsTextField.text = ""
                        priceTextField.text = ""
                    }
                }
                else
                {
                    warnUserNoti()
                }
            }
        }
        else
        {
            let noti = UIAlertController(title: nil, message: "Please add or select a vehicle before adding an entry.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                
            })
            
            noti.addAction(okAction)
            
            self.presentViewController(noti, animated: true, completion: nil)
        }
        
        
        dateTextField.resignFirstResponder()
        odometerTextField.resignFirstResponder()
        gallonsTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
    }
    
    func vehiclesExist() -> Bool
    {
        if let vehicles = RealmManager.getAllVehicles()
        {
            if vehicles.count > 0
            {
                return true
            }
        }
        
        return false
    }
    
    func warnUserNoti()
    {
        print("Please fill in all text fields.") // Notify user.
        
        let noti = UIAlertController(title: nil, message: "All fields are required before adding a new entry.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
        })
        
        noti.addAction(okAction)
        
        self.presentViewController(noti, animated: true, completion: nil)
    }
    
    func reloadTable()
    {
        tableView.reloadData()
    }
    
    func loadVehicleData()
    {
        // Load vehicle from db.
        if let currentVehicleName = NSUserDefaults.standardUserDefaults().objectForKey(CONSTANTS.NSUSERDEFAULTS.CURRENTLY_SELECTED_VEHICLE_NAME) as? String
        {
            self.entries.removeAll()
            if let vehicle = try! Realm().objects(Vehicle).filter("name == '\(currentVehicleName)'").first
            {
                
                for entry in vehicle.entries.sorted("mileage", ascending: false) // Maybe change to date?
                {
                    self.entries.append(entry)
                }
            }
            
            reloadTable()
        }
        
    }
    
    func loadVehicle(name: String) -> Vehicle?
    {
        // Load vehicle from db.
        if let vehicle = try! Realm().objects(Vehicle).filter("name == '\(name)'").first
        {
            return vehicle
        }
        
        return nil
    }
    
    
    func setupTextFields()
    {
        // Date TextField
        dateTextField.clearButtonMode = .WhileEditing
        dateTextField.font = UIFont(name: (dateTextField.font?.fontName)!, size: 16)
        dateTextField.textColor = StyleKit.red
        dateTextField.backgroundColor = UIColor.clearColor()
        
        dateTextField.titleLabel = UILabel()
        dateTextField.titleLabel!.font = UIFont(name: (dateTextField.font?.fontName)!, size: 12)
        dateTextField.titleLabelColor = UIColor.darkGrayColor()
        dateTextField.titleLabelActiveColor = StyleKit.white
        
        dateTextField.attributedPlaceholder = NSAttributedString(string:"Date", attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        dateTextField.layer.borderWidth = 0.0
        dateTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        // Mileage TextField
        odometerTextField.clearButtonMode = .WhileEditing
        odometerTextField.font = UIFont(name: (odometerTextField.font?.fontName)!, size: 16)
        odometerTextField.textColor = StyleKit.red
        odometerTextField.backgroundColor = UIColor.clearColor()
        
        odometerTextField.titleLabel = UILabel()
        odometerTextField.titleLabel!.font = UIFont(name: (odometerTextField.font?.fontName)!, size: 12)
        odometerTextField.titleLabelColor = UIColor.darkGrayColor()
        odometerTextField.titleLabelActiveColor = StyleKit.white
        
        odometerTextField.attributedPlaceholder = NSAttributedString(string:"Mileage", attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        odometerTextField.layer.borderWidth = 0.0
        odometerTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        // Gallons TextField
        gallonsTextField.clearButtonMode = .WhileEditing
        gallonsTextField.font = UIFont(name: (gallonsTextField.font?.fontName)!, size: 16)
        gallonsTextField.textColor = StyleKit.red
        gallonsTextField.backgroundColor = UIColor.clearColor()
        
        gallonsTextField.titleLabel = UILabel()
        gallonsTextField.titleLabel!.font = UIFont(name: (gallonsTextField.font?.fontName)!, size: 12)
        gallonsTextField.titleLabelColor = UIColor.darkGrayColor()
        gallonsTextField.titleLabelActiveColor = StyleKit.white
        
        gallonsTextField.attributedPlaceholder = NSAttributedString(string:"Gallons", attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        gallonsTextField.layer.borderWidth = 0.0
        gallonsTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        // Price TextField
        priceTextField.clearButtonMode = .WhileEditing
        priceTextField.font = UIFont(name: (priceTextField.font?.fontName)!, size: 16)
        priceTextField.textColor = StyleKit.red
        priceTextField.backgroundColor = UIColor.clearColor()
        
        priceTextField.titleLabel = UILabel()
        priceTextField.titleLabel!.font = UIFont(name: (priceTextField.font?.fontName)!, size: 12)
        priceTextField.titleLabelColor = UIColor.darkGrayColor()
        priceTextField.titleLabelActiveColor = StyleKit.white
        
        priceTextField.attributedPlaceholder = NSAttributedString(string:"Price", attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        priceTextField.layer.borderWidth = 0.0
        priceTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    // MARK: - CLLocationManagerDelegate - Refactor code into LocationManager.swift asap.
    
    // Get GPS coords.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        if gpsQueryLimit < 5
        {
            gpsQueryLimit = gpsQueryLimit + 1
        }
        else
        {
            // Stop collecting gps data when all we need is a quick sample.
            if CLLocationManager.locationServicesEnabled() {
                locationManager.stopUpdatingLocation()
            }
            
            // Reset query.
            gpsQueryLimit = 0
        }
        
        lat = Double(locValue.latitude)
        lon = Double(locValue.longitude)
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("entryCell", forIndexPath: indexPath) as! EntryTableViewCell
    
        // Date.
        cell.dateLabel.text = updateDateInUI(entries[indexPath.row].date)
        
        // MPG.
        cell.mpgLabel.text = "\(entries[indexPath.row].mpg)"
        
        // Gallons.
        cell.gallonsLabel.text = "\(entries[indexPath.row].gallons.roundToPlaces(1))"
        
        // Mileage.
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        cell.mileageLabel.text = "\(formatter.stringFromNumber(entries[indexPath.row].mileage)!)"
        
        // Price.
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        cell.priceLabel.text = "\(formatter.stringFromNumber(entries[indexPath.row].price)!)" // format $0.0
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 23
    }
    
    
    
    // Override to support conditional editing of the table view.
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }

    
    
    // Delete entry from db.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Delete entry from db.
            RealmManager.deleteEntry(entries[indexPath.row])
            
            // Reload data in memory for display.
            loadVehicleData()
            
            // Remove visible row.
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        }
    }

    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.tag == 0 // Date.
        {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .Date
            textField.inputView = datePicker
            datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            odometerTextField.becomeFirstResponder()
        }
        else if textField.tag == 2 {
            gallonsTextField.becomeFirstResponder()
        }
        else if textField.tag == 3 {
            priceTextField.becomeFirstResponder()
        }
        else if textField.tag == 4 {
            addNewEntry()
            priceTextField.resignFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle
        dateTextField.text = formatter.stringFromDate(sender.date)
        
        date = sender.date
    }
    
    func updateDateInUI(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle
        return formatter.stringFromDate(date)
    }
    
    // MARK: - DZNEmptyTableView Delegate & DataSource.
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage!
    {
        return StyleKit.imageOfFuelIcon
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Zero, Zip, Zilch, Nada Entries"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
    
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "There are no fuel entries added to the current vehicle. If you just installed this app, please tap the menu icon top left and add a vehicle."
    
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


// MARK: - Extensions.

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
