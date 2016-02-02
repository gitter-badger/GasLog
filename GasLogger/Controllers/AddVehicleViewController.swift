//
//  AddVehicleViewController.swift
//  GasLogger
//
//  Created by Gene Crucean on 2/1/16.
//  Copyright © 2016 Dagger Dev. All rights reserved.
//

import UIKit
import Material

class AddVehicleViewController: BaseViewController, UITableViewDelegate, TextFieldDelegate {

    @IBOutlet weak var vehicleNameTextField: TextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Nav bar logo.
        let navBarLogo = StyleKit.imageOfVehicle_add
        let navBarLogoView = UIImageView(image: navBarLogo)
        self.navigationItem.titleView = navBarLogoView
        
        // Basic ui settings.
        
        // Add Button.
        addButton.tintColor = StyleKit.red
        
        // Name TextField.
        vehicleNameTextField.clearButtonMode = .WhileEditing
        vehicleNameTextField.font = UIFont(name: (vehicleNameTextField.font?.fontName)!, size: 16)
        vehicleNameTextField.textColor = StyleKit.red
        vehicleNameTextField.backgroundColor = UIColor.clearColor()
        
        vehicleNameTextField.titleLabel = UILabel()
        vehicleNameTextField.titleLabel!.font = UIFont(name: (vehicleNameTextField.font?.fontName)!, size: 12)
        vehicleNameTextField.titleLabelColor = StyleKit.lightGrey
        vehicleNameTextField.titleLabelActiveColor = StyleKit.lightGrey
        
        vehicleNameTextField.attributedPlaceholder = NSAttributedString(string:"Name", attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        vehicleNameTextField.layer.borderWidth = 0.0
        vehicleNameTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        // Set textfield to active.
        vehicleNameTextField.becomeFirstResponder()
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
    
    // MARK: - METHODS

    @IBAction func addButton(sender: AnyObject) {
        vehicleNameTextField.resignFirstResponder()
        addVehicleToDB()
    }
    
    func addVehicleToDB()
    {
        if vehicleNameTextField.text?.characters.count != 0
        {
            if let name = vehicleNameTextField.text
            {
                let vehicle = Vehicle()
                vehicle.name = name
                vehicle.uuid = NSUUID().UUIDString
                
                RealmManager.addVehicleToDB(vehicle)
                
                NSUserDefaults.standardUserDefaults().setObject(name, forKey: CONSTANTS.NSUSERDEFAULTS.CURRENTLY_SELECTED_VEHICLE_NAME)
                
                vehicleNameTextField.text = ""
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
    }
    
    @IBAction func tapGesture(sender: AnyObject) {
        vehicleNameTextField.resignFirstResponder()
    }
    
    
    // MARK: - TextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addVehicleToDB()
        return false
    }
}
