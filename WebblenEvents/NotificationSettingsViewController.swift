//
//  NotificationSettingsViewController.swift
//  WebblenEvents
//
//  Created by Aditya Bhasin on 9/10/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit

class NotificationSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var notifyWithin = ["1 mile", "5 miles", "10 miles" ]
    
    
    var notificationDistance = "1 mile"
    var event18 = false
    var event21 = false
    var price = "4.99"
    var event18String = ""
    var event21String = ""
    
    @IBOutlet weak var event18Switch: UISwitch!
    
    @IBOutlet weak var event21Switch: UISwitch!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    @IBOutlet weak var notifyLabel: UILabel!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Notification Occurence Picker View
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return notifyWithin[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return notifyWithin.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        notifyLabel.text = "Notify Users Within " + notifyWithin[row]
        notificationDistance = notifyWithin[row]
    }
    
    
    
    //Outlets & Functions
    @IBOutlet weak var notificationsPicker: UIPickerView!
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var eventPriceLabel: UILabel!
   

    
    @IBAction func didPressConfirm(_ sender: Any) {
        
        if (event18Switch.isOn){
            event18 = true
            event18String = "18+"
        }
        else {
            event18 = false
        }
        
        if (event21Switch.isOn && event18Switch.isOn){
            
            event18 = false
            event18String = ""
            
            event21 = true
            event21String = "21+"
        }
        else if (event21Switch.isOn){
            event21 = true
            event21String = "21+"
        }
        
        if let presenter = presentingViewController as? NewEventViewController{
            
            if (event18 == true){
            presenter.modifyNotification.setTitle("Notify Within: " + notificationDistance + ", " + event18String + ", $4.99", for: .normal)
            }
            else if (event21 == true && event18 == false){
            presenter.modifyNotification.setTitle("Notify Within: " + notificationDistance + ", " + event21String + ", $4.99", for: .normal)
            }
            else {
            presenter.modifyNotification.setTitle("Notify Within: " + notificationDistance + ", $4.99", for: .normal)
            }
            //presenter.eventRadius = notificationDistance
            presenter.event18 = event18
            presenter.event21 = event21
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
