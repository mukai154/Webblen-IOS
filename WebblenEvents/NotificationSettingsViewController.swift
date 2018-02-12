//
//  NotificationSettingsViewController.swift
//  WebblenEvents
//
//  Created by Aditya Bhasin on 9/10/17.
//  Copyright © 2017 Mukai Selekwa. All rights reserved.
//

import UIKit

class NotificationSettingsViewController: UIViewController {
    
    var event18 = false
    var event21 = false
    var notificationOnly = false
    
    @IBOutlet weak var event18Switch: UISwitch!
    
    @IBOutlet weak var event21Switch: UISwitch!
    @IBOutlet weak var notificationOnlySwitch: UISwitch!
    @IBOutlet weak var notificationInfoButton: UIButton!
    
    var helpCircle = UIImage(named: "help-circle")?.withRenderingMode(.alwaysTemplate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationInfoButton.setImage(helpCircle, for: .normal)
        notificationInfoButton.tintColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


   
    @IBAction func didPressQuestion(_ sender: Any) {
        showAlert(withTitle: "Notification Only Event", message: "Only those within your set notification radius will be able to view your event.")
    }
    
    
    @IBAction func didPressConfirm(_ sender: Any) {
        
        if (notificationOnlySwitch.isOn){
            notificationOnly = true
        }
        if (event18Switch.isOn){
            event18 = true
        }
        
        if (event21Switch.isOn){
            event21 = true
        }
        if (event21Switch.isOn && event18Switch.isOn){
            event21 = false
        }
        
        if let presenter = presentingViewController as? NewEventViewController{
            
            if (event18 == true){
            presenter.modifyNotification.setTitle("18+ Event", for: .normal)
            }
            else if (event21 == true){
                presenter.modifyNotification.setTitle("21+ Event", for: .normal)
            }
            else if (notificationOnly == true){
                presenter.modifyNotification.setTitle("Notification Only", for: .normal)
            }
            else if (notificationOnly == true && event18 == true){
                presenter.modifyNotification.setTitle("Notification Only, 18+ Event", for: .normal)
            }
            else if (notificationOnly == true && event21 == true){
                presenter.modifyNotification.setTitle("Notification Only, 21+ Event", for: .normal)
            }
            else {
               presenter.modifyNotification.setTitle("Event Filter Settings", for: .normal)
            }
            //presenter.eventRadius = notificationDistance
            presenter.event18 = event18
            presenter.event21 = event21
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
