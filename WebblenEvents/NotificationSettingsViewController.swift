//
//  NotificationSettingsViewController.swift
//  WebblenEvents
//
//  Created by Aditya Bhasin on 9/10/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit

class NotificationSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var notifyWhen = ["Day Of Event", "Day Before Event", "Every Day" ]
    
    
    var notificationFrequency = "Day of Event"
    var event18 = false
    var event21 = false
    var price = "4.99"
    var miles = 1
    var charge = 4
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
        return notifyWhen[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return notifyWhen.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        notifyLabel.text = "Notify Users " + notifyWhen[row]
        notificationFrequency = notifyWhen[row]
    }
    
    
    
    //Outlets & Functions
    @IBOutlet weak var notificationsPicker: UIPickerView!
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
   
    @IBAction func distanceSlider(_ sender: UISlider) {
        
        distanceLabel.text = "Notify Those Within: " + String(Int(sender.value)) + " miles"
        
        miles = Int(sender.value)
        
        
        
        
    }
    
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
            presenter.modifyNotification.setTitle("Notify " + notificationFrequency + ", " + event18String + event21String + ", $4.99", for: .normal)
            
            presenter.notifyDistance = miles
            presenter.event18 = event18
            presenter.event21 = event21
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
